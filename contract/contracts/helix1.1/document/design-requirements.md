# Framework Contract Design Requirements
## Condition checks
- all conditions must be checked at the entrance point of any command. e.g. Client submit a task, whether this client is submissible or not should be checked before the task is created
- all following functions will assume that anything it takes is valid

## Logic modules
- Contain all the API entry points and all the condition checkers
- Implement each a Miner, Client, Other two logic modules' interface
- Should not directly interact the data container of the other logic modules. With ONLY one exception: if the returning variable is a string, due to the native solidity limitation on variable length storage type.
  
## Data modules 
- NO checker logic should be here, it is simply a database on blockchain, so it should be seen as a database only: store data and modify data.
- Interface should only be provided for the logic module of its own type only. With ONLY one exception: if the returning variable is a string, due to the native solidity limitation on variable length storage type. In this case, a single getter only interface should be provided.
- Modifier should limit to its master module and Owner ONLY

## Testing
- All Modules should be independently testable
- All Module pairs should be independently testable
- Automation is possible, requires either python or Js (these two are better supported, especially Js) and highly recommended
- Corner cases design are especially important. Note all numbers are unsigned, No negation should be one of the most important checking point.
- A new local testing node will be created for testing for efficiency

## Documentation
- A flow chart and UML will be created and append to this document soon.
- All functions that is not the entry point of the execution procedure should indicate where a variable has been checked in @dev section

## Misc
- TBD
