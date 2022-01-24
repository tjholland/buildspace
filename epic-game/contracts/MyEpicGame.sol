// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// ERC721 contract
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// helper functions
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";
import "./libraries/Base64.sol";

contract MyEpicGame is ERC721 {
    // character attributes, will add more later
    // ideas: clan, 
    struct CharacterAttributes {
        uint characterIndex;
        string name;
        // string class;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
        // uint critChance;
        // uint defense;
    }

    struct BigBoss {
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    BigBoss public bigBoss;

    // token id
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // array for the default characters
    CharacterAttributes[] defaultCharacters;

    // mapping of token id to attributes
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // mapping of address to token id
    mapping(address => uint256) public nftHolders;

    // data passed when the contract is first created    
    constructor(
        string[] memory characterNames,
        // string[] memory characterClasses,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDamage,
        // uint[] memory characterCritChance,
        // uint[] memory characterDefense,
        string memory bossName,
        string memory bossImageURI,
        uint bossHp,
        uint bossAttackDamage
    )
        ERC721("Heroed", "HEROd") 
    {
        // big boss
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage
        });

    console.log("Done intializing boss %s with HP %s, img %s", bigBoss.name, bigBoss.hp, bigBoss.imageURI);

        for(uint i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                // class: characterClasses[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDamage[i]
                // critChance: characterCritChance[i],
                // defense: characterDefense[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log('Done initializing %s with HP %s, img %s', c.name, c.hp, c.imageURI);
        }
        // first token id = 1
        _tokenIds.increment();
    }

    // users will mint based on their characterId
    function mintCharacterNFT(uint _characterIndex) external {
        // get current tokenId
        uint256 newItemId = _tokenIds.current();

        // assigns tokenId to caller's wallet address
        _safeMint(msg.sender, newItemId);

        // map the tokenId to their character's attributes
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log("Minted NFT with tokenId %s and characterIndex %s", newItemId, _characterIndex);

        // keep an easy way to see who owns what NFT
        nftHolders[msg.sender] = newItemId;

        // increment the tokenId for the next person that uses it
        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "', charAttributes.name,
                ' --NFT #: ', Strings.toString(_tokenId),
                '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
                charAttributes.imageURI,
                '", "attributes": [ { "trait_type": "Health Points", "value":, ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
                strAttackDamage,'} ]}'
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    function attackBoss() public {
        // get the state of the player's NFT
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
        console.log("\nPlayer with character %s about to attack. Has %s HP and %s AD", player.name, player.hp, player.attackDamage);
        console.log("Boss %s has %s HP and %s AD", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);

        // make sure the player has more than 0 hp
        require (
            player.hp > 0,
            "Error: character must have HP to attack boss"
        );

        // make sure the boss has more than 0 hp
        require (
            bigBoss.hp > 0,
            "Error: boss must have HP to be attacked"
        );

        // allow the player to attack the boss
        if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
        } else {
            bigBoss.hp = bigBoss.hp - player.attackDamage;
        }

        // allow the boss to attack the player
        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = player.hp - bigBoss.attackDamage;
        }

        // console for ease
        console.log("Player attacked the boss. New boss HP: %s", bigBoss.hp);
        console.log("Boss attacked the player. New player HP: %s", player.hp);
    }
}