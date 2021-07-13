pragma solidity >=0.7.0 <0.9.0;
pragma abicoder v2;
contract cryptoTrades
{
    string name = "CryptoTrades";
    string simbol = "CTT";
    struct npc
    {
        uint256 bal;
        string name;
        uint256 ambition;
        uint256 caution;
    }
    npc[] npcs;
    struct materials
    {
        uint256 iron;
        uint256 gold;
        uint256 plat;
    }
    struct player
    {
        materials mats;
        uint256 withdrawable_revenue;
    }
    struct prices_
    {
        uint256 iron;
        uint256 gold;
        uint256 plat;
    }
    prices_ prices;
    mapping (address => uint256) balance;
    mapping (address => player) players;
    
    function sell_iron(uint256 other_trader, uint256 amount, uint256 price) public {
        player memory p = players[msg.sender];
        uint256 pr = price;
        uint256 default_price = prices.iron; //change this too
        npc memory n = npcs[other_trader];
        uint256 odds = n.ambition / n.caution;
        if (uint256(keccak256(abi.encodePacked(blockhash(block.number)))) / uint256(16) ** uint256(64) / 10 <= odds * default_price/price) {
            n.bal -= amount * pr;
            default_price -= amount / 100000 * pr;
            n.caution += amount;
            n.ambition -= amount - 1;
            p.withdrawable_revenue += amount * pr;
            npcs[other_trader] = n;
            p.mats.iron -= amount; //change this with the next one
            players[msg.sender] = p;
            prices.iron = default_price;
        }
    }
    function sell_gold(uint256 other_trader, uint256 amount, uint256 price) public {
        player memory p = players[msg.sender];
        uint256 pr = price;
        uint256 default_price = prices.gold; //change this too
        npc memory n = npcs[other_trader];
        uint256 odds = n.ambition / n.caution;
        if (uint256(keccak256(abi.encodePacked(blockhash(block.number)))) / uint256(16) ** uint256(64) / 10 <= odds * default_price/price) {
            n.bal -= amount * pr;
            default_price -= amount / 100000 * pr;
            n.caution += amount;
            n.ambition -= amount - 1;
            p.withdrawable_revenue += amount * pr;
            npcs[other_trader] = n;
            p.mats.gold -= amount; //change this with the next one
            players[msg.sender] = p;
            prices.gold = default_price;
        }
    }
    function sell_plat(uint256 other_trader, uint256 amount, uint256 price) public {
        player memory p = players[msg.sender];
        uint256 pr = price;
        uint256 default_price = prices.plat; //change this too
        npc memory n = npcs[other_trader];
        uint256 odds = n.ambition / n.caution;
        if (uint256(keccak256(abi.encodePacked(blockhash(block.number)))) / uint256(16) ** uint256(64) / 10 <= odds * default_price/price) {
            n.bal -= amount * pr;
            default_price -= amount / 100000 * pr;
            n.caution += amount;
            n.ambition -= amount - 1;
            p.withdrawable_revenue += amount * pr;
            npcs[other_trader] = n;
            p.mats.plat -= amount; //change this with the next one
            players[msg.sender] = p;
            prices.plat = default_price;
        }
    }
    function buy_iron(uint256 other_trader, uint256 amount, uint256 price) public {
        player memory p = players[msg.sender];
        uint256 pr = price;
        uint256 default_price = prices.iron; //change this too
        npc memory n = npcs[other_trader];
        uint256 odds = n.ambition / n.caution;
        if (uint256(keccak256(abi.encodePacked(blockhash(block.number)))) / uint256(16) ** uint256(64) / 10 <= odds * price/default_price) {
            n.bal += amount * pr;
            default_price += amount / 100000 * pr;
            n.caution -= amount;
            n.ambition += amount;
            p.withdrawable_revenue -= amount * pr;
            npcs[other_trader] = n;
            p.mats.iron += amount; //change this with the next one
            players[msg.sender] = p;
            prices.iron = default_price; //change this as well
        }
    }
    function buy_gold(uint256 other_trader, uint256 amount, uint256 price) public {
        player memory p = players[msg.sender];
        uint256 pr = price;
        uint256 default_price = prices.gold; //change this too
        npc memory n = npcs[other_trader];
        uint256 odds = n.ambition / n.caution;
        if (uint256(keccak256(abi.encodePacked(blockhash(block.number)))) / uint256(16) ** uint256(64) / 10 <= odds * price/default_price) {
            n.bal += amount * pr;
            default_price += amount / 100000 * pr;
            n.caution -= amount;
            n.ambition += amount;
            p.withdrawable_revenue -= amount * pr;
            npcs[other_trader] = n;
            p.mats.gold += amount; //change this with the next one
            players[msg.sender] = p;
            prices.gold = default_price; //change this as well
        }
    }
    function buy_plat(uint256 other_trader, uint256 amount, uint256 price) public {
        player memory p = players[msg.sender];
        uint256 pr = price;
        uint256 default_price = prices.plat; //change this too
        npc memory n = npcs[other_trader];
        uint256 odds = n.ambition / n.caution;
        if (uint256(keccak256(abi.encodePacked(blockhash(block.number)))) / uint256(16) ** uint256(64) / 10 <= odds * price/default_price) {
            n.bal += amount * pr;
            default_price += amount / 100000 * pr;
            n.caution -= amount;
            n.ambition += amount;
            p.withdrawable_revenue -= amount * pr;
            npcs[other_trader] = n;
            p.mats.plat += amount; //change this with the next one
            players[msg.sender] = p;
            prices.plat = default_price; //change this as well
        }
    }
    
    function playerstats() public view returns(player memory you) {
        return players[msg.sender];
    }
    
    uint256 total_supply = 0;
    function withdraw(uint256 amount) public {
        if (players[msg.sender].withdrawable_revenue >= amount) {
            players[msg.sender].withdrawable_revenue -= amount;
            balance[msg.sender] += amount;
            total_supply += amount;
        }
    }
    function go_mining(uint256 amount) public {
        if (balance[msg.sender] > amount) {
            balance[msg.sender] -= amount;
            players[msg.sender].mats.iron += 10 * amount;
            players[msg.sender].mats.gold += amount;
            if (amount >= 1000) {
                players[msg.sender].mats.plat += 1;
            }
            total_supply -= amount;
        }
    }
    function send(address reciever, uint256 amount) public {
        if (balance[msg.sender] >= amount) {
            balance[msg.sender] -= amount;
            balance[reciever] += amount;
        }
    }
    function fetchBal() public view returns(uint256 your_bal_is) {
        return balance[msg.sender];
    }
    function new_npc() public {
        if (msg.sender == 0x751329B3A2a92FBEffDAC3Eaa5F9fBeA7584a0bC) {
            npcs.push(npc(1000, 'bob', 1000, 1000));
        }
    }
    function mint() public returns(string memory didWork){
        if (msg.sender == 0x751329B3A2a92FBEffDAC3Eaa5F9fBeA7584a0bC) {
            balance[0x751329B3A2a92FBEffDAC3Eaa5F9fBeA7584a0bC] += 100;
            total_supply += 100;
            return "ye it worked";
        }
        else {
            return "opps, you do not own the game, no hacking";
        }
    }
    constructor(uint256 alloc) {
        balance[0x751329B3A2a92FBEffDAC3Eaa5F9fBeA7584a0bC] = alloc;
        total_supply = alloc;
    }
}
