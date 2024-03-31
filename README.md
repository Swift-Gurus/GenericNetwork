# Voodoo Adn project

## Overview

Voodoo Adn is Voodoo's in-app monetization solution.

## Getting Started

### Dependencies

Before starting working with the project run the next command
```
 make setup
```
It's a sript that will install
* Dependencies
  * bundle
  * xcodegen  
  * swiftlint 
  * rbenv 
  * git hooks
* Ensures that
  * all dependencies are present 
  * ruby env are set

### Installing

*  Using Cocoapods 

### Executing program

```
 ./create-xcframework.sh Debug
```

to build a release version script run
```
 ./create-xcframework.sh Release
```

### Contribution
* We use the GitFlow Workflow
    * Git Flow: Develop Branch
    * Git Flow: Feature Branch 
    * Git Flow: Release Branch

Please follow the voodoo guideline documentation (here)

* We follow the clean architecture paradigm to structure the code in this project.
please follow the voodoo iOS clean architecture documentation (here)


## Project Structure

 * Voodoo Adn workspace under *adn-io-app*

## Version History

* 2.1.2.1
    * Update to the VS C# JSON serializer, to remove the presence of a 'null' value in the JSON payload
    *  Update the iOS serializer to accept the null value when decoding the string params on json 
    *  Remove mutate attribute on isInit value 

## License

This project is licensed under the mit License - see the LICENSE.md file for details
