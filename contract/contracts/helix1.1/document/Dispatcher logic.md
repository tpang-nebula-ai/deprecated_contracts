# Dispatch

## Join
### When Ai join to queue: (same logic for task)
1. both queue empty
    1. join ai queue and wait
    2. if a task comes in, task_join triggers dispatchable() and dispatch
2. ai queue not empty, task queue empty
    1. join ai queue and wait
    2. if a task comes in, task_join triggers dispatchable() and dispatch
3. ai queue empty, task queue not empty
    1. dispatchable() triggers dispatch, Ai not joining queue and start working immediately 
4. both queue not empty
    1. should not be reachable normally, except, when contract is resumed from pausing.
### Condition checks
* Task is not checked here (in Distributor)
* Ai should be eligible (must be not banned if eligible), not working and not waiting 
    
## leave

## rejoin
