package company

import (
	"collections"
	"time"
	"math/rand"
	"config"
	"fmt"
	"math_machines"
)

func Chairman (taskServer chan *collections.TaskToDo) {
	rand.Seed(time.Now().UTC().UnixNano())
	var interval time.Duration
	counter := 1
	for {
		tempTask := collections.CreateTask(counter, counter+2, counter%3)
		taskServer <- tempTask
		if config.CompanyTalkative == true {
			fmt.Print("Created task number ")
			fmt.Print(counter)
			fmt.Print(". : ")
			fmt.Print(tempTask.ParamA)
			fmt.Print(" ")
			if tempTask.Operator == 0 {
				fmt.Print("+ ")
			}
			if tempTask.Operator == 1 {
				fmt.Print("- ")
			}
			if tempTask.Operator == 2 {
				fmt.Print("* ")
			}
			fmt.Print(tempTask.ParamB)
			fmt.Println()
		}

		counter++
		interval = time.Duration(rand.Intn(15))
		time.Sleep(time.Second * interval)
	}
}

func Worker (taskServer chan *collections.TaskToDo,
	productServer chan *collections.TaskToDo,
	addMachineServer chan *math_machines.AddMachine,
	minusMachineServer chan *math_machines.MinusMachine,
	multipleMachineServer chan *math_machines.MultipleMachine,
	waitingHelpMachineServer chan *math_machines.MultipleMachine,
	multipleMachineWithHelperServer chan *math_machines.MultipleMachine,
	damagedAddMachines chan *math_machines.AddMachine,
	damagedMinusMachines chan *math_machines.MinusMachine,
	damagedMultipleMachines chan *math_machines.MultipleMachine,
	number int){
	hasMachine := false
	time.Sleep(time.Second * time.Duration(config.WorkersGoingToWorkTime))
	for {
		fmt.Println("If it is possible to help...?")
		if len(waitingHelpMachineServer) > 0 {
			fmt.Println("Worker Wanna help!")
			tempWaitingMachine := <- waitingHelpMachineServer
			if config.CompanyTalkative == true {
				fmt.Print("Worker number: ")
				fmt.Print(number)
				fmt.Println(" is helping with multiple machine!")
			}
			multipleMachineWithHelperServer <- tempWaitingMachine
		}
		fmt.Println("Taking task from server")
		tempProduct := <-taskServer
		var tempAddMachine *math_machines.AddMachine
		if tempProduct.Operator == 0 {
			for hasMachine != true{
				tempAddMachine = <- addMachineServer
				if config.CompanyTalkative {
					fmt.Print("Worker number: ")
					fmt.Print(number)
					fmt.Println(" is using add machine!")
				}
				result := RandomDamage()
				if result == false {
					hasMachine = true
				} else {
					fmt.Print("Add machine has beed damaged!")
					damagedAddMachines <- tempAddMachine
				}
			}

			tempAddMachine.UseAsSolver(tempProduct)
			addMachineServer <- tempAddMachine
			productServer <- tempProduct
			hasMachine = false
		}

		if tempProduct.Operator == 1 {
			var tempMinusMachine *math_machines.MinusMachine

			for hasMachine != true{
				tempMinusMachine = <- minusMachineServer
				if config.CompanyTalkative {
					fmt.Print("Worker number: ")
					fmt.Print(number)
					fmt.Println(" is using minus machine!")
				}
				result := RandomDamage()
				if result == false {
					hasMachine = true
				} else {
					fmt.Print("Minus machine has beed damaged!")
					damagedMinusMachines <- tempMinusMachine
				}
			}
			tempMinusMachine.UseAsSolver(tempProduct)
			minusMachineServer <- tempMinusMachine
			productServer <- tempProduct
			hasMachine = false
		}

		if tempProduct.Operator == 2 {
			var tempMultipleMachine *math_machines.MultipleMachine
			for hasMachine != true{
				tempMultipleMachine = <- multipleMachineServer
				if config.CompanyTalkative {
					fmt.Print("Worker number: ")
					fmt.Print(number)
					fmt.Println(" is using add machine!")
				}
				result := RandomDamage()
				if result == false {
					hasMachine = true
				} else {
					fmt.Print("Multiple machine has beed damaged!")
					damagedMultipleMachines <- tempMultipleMachine
				}
			}
			waitingHelpMachineServer <- tempMultipleMachine
			tempMultipleMachine = <- multipleMachineWithHelperServer
			tempMultipleMachine.SolveTask(tempProduct)
			multipleMachineServer <- tempMultipleMachine
			productServer <- tempProduct
			hasMachine = false
		}
		if config.CompanyTalkative == true {
			fmt.Print("Worker number: ")
			fmt.Print(number)
			fmt.Print(" solved task: ")
			fmt.Print(tempProduct.ParamA)
			fmt.Print(" ")
			if tempProduct.Operator == 0 {
				fmt.Print("+ ")
			}
			if tempProduct.Operator == 1 {
				fmt.Print("- ")
			}
			if tempProduct.Operator == 2 {
				fmt.Print("* ")
			}
			fmt.Print(tempProduct.ParamB)
			fmt.Println()
		}

		time.Sleep(time.Second * time.Duration(config.WorkersBreak))
	}
}

func Customer (productServer chan *collections.TaskToDo) {
	time.Sleep(time.Second * time.Duration(config.CustomerGoingToStoreTime))
	for {
		tempProduct := <- productServer
		if config.CompanyTalkative == true {
			fmt.Print("Product bought: ")
			fmt.Print(tempProduct.ParamA)
			fmt.Print(" ")
			if tempProduct.Operator == 0 {
				fmt.Print("+ ")
			}
			if tempProduct.Operator == 1 {
				fmt.Print("- ")
			}
			if tempProduct.Operator == 2 {
				fmt.Print("* ")
			}
			fmt.Print(tempProduct.ParamB)
			fmt.Print(" = ")
			fmt.Print(tempProduct.Solution)
			fmt.Println()
		}
		time.Sleep(time.Second * time.Duration(config.CustomerBreak))
	}
}

func Handyman(addMachineServer chan *math_machines.AddMachine,
	minusMachineServer chan *math_machines.MinusMachine,
	multipleMachineServer chan *math_machines.MultipleMachine,
	damagedAddMachines chan *math_machines.AddMachine,
	damagedMinusMachines chan *math_machines.MinusMachine,
	damagedMultipleMachines chan *math_machines.MultipleMachine) {
	fmt.Println("Handyman started his day!")
	for {
		fmt.Println("Routine handyman tour!")
		if len(damagedAddMachines) > 0 {
			if config.CompanyTalkative {
				fmt.Println("Repairing add machine!")
			}
			tempAddMachine := <- damagedAddMachines
			time.Sleep(time.Second * time.Duration(config.RepairTime))
			addMachineServer <- tempAddMachine
		}
		if len(damagedMinusMachines) > 0 {
			if config.CompanyTalkative {
				fmt.Println("Repairing minus machine!")
			}
			tempMinusMachine := <- damagedMinusMachines
			time.Sleep(time.Second * time.Duration(config.RepairTime))
			minusMachineServer <- tempMinusMachine
		}
		if len(damagedMultipleMachines) > 0 {
			if config.CompanyTalkative {
				fmt.Println("Repairing multiple machine!")
			}
			tempMultipleMachine := <- damagedMultipleMachines
			time.Sleep(time.Second * time.Duration(config.RepairTime))
			multipleMachineServer <- tempMultipleMachine
		}
		time.Sleep((time.Second * time.Duration(config.HandymanBreakTime)))
	}
}

func RandomDamage() bool {
	rand.Seed( time.Now().UTC().UnixNano())
	result := rand.Intn(100)
	if result > config.DamageBorder {
		return true
	}
	return false
}
