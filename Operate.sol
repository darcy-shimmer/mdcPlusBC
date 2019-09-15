pragma solidity ^0.4.17;

//import "./Mdcs.sol.sol";

contract Operate {

    //Events//
    event PostTask(uint id_task);

    //Structs//
    struct task {
        uint resolution;
        uint size;
        uint difficulty;
        //false represents unfinished.
        bool state;
        //任务完成的评价（viewers mark）
        int8 result;
        //assigned worker's id and 0 represents untaken
        uint workerid;
    }

    //引用 Mdcs.sol.sol
    //  Mdcs.sol public t;
    //  constructor(address t1) public {
    //      t = Mdcs.sol(t1);
    //  }

    // 状态变量 //
    uint public numberOftask;
    uint public id_task;


    // Mappings //
    mapping (uint => task) tasks;

    //Constructor//
    //  constructor() public {
    //      /* For the case of demo, adding a customer in constructor. You can take this idea and extend the contract to contain addCustomer section and hence maintain customerDB in the Blockchain! */
    //      customers[0] = AvailableCustomer(1, "John Snow");
    //  }

    //Functions//
    function posttask(uint _res, uint _size) public returns(uint){
        id_task ++;
        numberOftask ++;
        uint _diff = _res * _size;
        tasks[id_task] = task(_res, _size, _diff, false, 0, 0);
        PostTask(id_task);
        return(_diff);
    }


    //  function assigntask(uint _task_id, uint _workerid) public {

    //  }

    function evaluate(uint _task_id, bool _sc) {
        if(_sc) {
            tasks[_task_id].result ++;
        } else {
            tasks[_task_id].result = tasks[_task_id].result - 1;
        }
    }

    //修改task的任务执行主体
    function correctWorker(uint _task_id, uint _workerid) public {
        tasks[_task_id].workerid = _workerid;
    }
    //修改task的状态
    function correctState(uint _task_id) public {
        tasks[_task_id].state = true;
    }

    // GETTERS //
    //获取task评价结果
    function getTaskEva(uint _task_id) view public returns (bool){
        bool _result;
        if(tasks[_task_id].result < 0){
            _result = false;
        } else {
            _result = true;
        }
        return (_result);
    }
    //获取task的信息
    function getTaskInformation(uint _taskid) view public returns (uint, uint, uint, bool, int8, uint) {
        return (tasks[_taskid].resolution, tasks[_taskid].size, tasks[_taskid].difficulty, tasks[_taskid].state, tasks[_taskid].result, tasks[_taskid].workerid);
    }
}