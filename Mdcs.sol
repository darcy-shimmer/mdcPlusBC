pragma solidity ^0.4.17;
contract Mdcs {
    //Events//
    event AddWorkers(uint id_worker);

    //Structs//
    //worker的信息表
    struct inf_mdc {
        address mdc_address;
        //true means occupied;false means available
        bool state;
        //信誉度
        uint reputation;
        //能力（算力）
        uint capacity;
        //代币或者积分
        uint money;
    }

    //状态变量
    uint public numberofworkers;
    uint public id_worker;
    //任务完成后的报酬 money+amount
    uint public amount=10;
    //任务完成后信誉度增减值
    uint public amount_re=10;

    //Mappings//
    //记录所有workers的表
    mapping (uint => inf_mdc) inf_mdcs;

    //Functions//
    //worker注册
    function addWorkers(address _mdc_address, uint _rep, uint _cap) public {
        id_worker ++;
        numberofworkers ++;
        inf_mdcs[id_worker] = inf_mdc(_mdc_address, false, _rep, _cap, 100);
        AddWorkers(id_worker);
    }

    //任务分配
    function assign(uint _diff) public returns(uint) {
        for (uint i = 0; i < numberofworkers; i++ ){
            if (inf_mdcs[i].capacity >= _diff){
                if (inf_mdcs[i].state == false){
                    if (inf_mdcs[i].reputation > 0){
                        inf_mdcs[i].state = true;
                        return(i);
                    }
                }
            }
        }
        //若没有满足算力的worker，抛出异常
        assert(1>2);
        return;
    }

    //GETTER//
    //获取worker地址
    function getWorkerAddress(uint _id) view public returns (address) {
        return inf_mdcs[_id].mdc_address;
    }
    //获取worker信息(except address)
    function getWorkerInformation(uint _id) view public returns (bool, uint, uint, uint) {
        return (inf_mdcs[_id].state, inf_mdcs[_id].reputation, inf_mdcs[_id].capacity, inf_mdcs[_id].money);
    }

    //代币交易
    address public minter;
    event Send(address from, uint to, uint amount);
    function Mdcs() {
        minter = msg.sender;
    }

    function sendReward(uint _id, bool _result) {
        //make sure that only hte operator can call this function
        if (msg.sender != minter) return;
        if (_result){
            inf_mdcs[_id].money += amount;
            inf_mdcs[_id].reputation += amount;
            Send(msg.sender, _id, amount);
        } else {
            inf_mdcs[_id].reputation += -amount;
        }
        if (inf_mdcs[_id].reputation > 0){
            inf_mdcs[_id].state = false;
        }
    }
}
