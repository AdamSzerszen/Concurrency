package factories

import (
	"collections"
	"time"
	"math/rand"
	"config"
	"math_machines"
	"fmt"
)

func (ft Factory) Chairman () {
	counter := 1
	for {
		fmt.Println("Creating new tasks in factory...")
		tempTask := collections.CreateTask(counter, counter+2, counter%3)
		ft.taskServer <- tempTask
		counter++
		time.Sleep(time.Second * 2)
	}
}

func (ft Factory) Worker (){
	hasMachine := false
	time.Sleep(time.Second * time.Duration(config.WorkersGoingToWorkTime))
	for {
		fmt.Println("Preparing products in factory...")
		if len(ft.waitingHelpMachineServer) > 0 {
			tempWaitingMachine := <- ft.waitingHelpMachineServer
			ft.multipleMachineWithHelperServer <- tempWaitingMachine
		}

		fmt.Println("Getting new tasks!")
		tempProduct := <-ft.taskServer
		var tempAddMachine *math_machines.AddMachine
		if tempProduct.Operator == 0 {
			for hasMachine != true{
				tempAddMachine = <- ft.addMachineServer
				result := RandomDamage()
				if result == false {
					hasMachine = true
				} else {
					ft.damagedAddMachines <- tempAddMachine
				}
			}

			tempAddMachine.UseAsSolver(tempProduct)
			ft.addMachineServer <- tempAddMachine
			ft.productServer <- tempProduct
			hasMachine = false
		}

		if tempProduct.Operator == 1 {
			var tempMinusMachine *math_machines.MinusMachine

			for hasMachine != true{
				tempMinusMachine = <- ft.minusMachineServer
				result := RandomDamage()
				if result == false {
					hasMachine = true
				} else {
					ft.damagedMinusMachines <- tempMinusMachine
				}
			}
			tempMinusMachine.UseAsSolver(tempProduct)
			ft.minusMachineServer <- tempMinusMachine
			ft.productServer <- tempProduct
			hasMachine = false
		}

		if tempProduct.Operator == 2 {
			fmt.Println("Multipling...")
			var tempMultipleMachine *math_machines.MultipleMachine
			for hasMachine != true{
				tempMultipleMachine = <- ft.multipleMachineServer
				result := RandomDamage()
				if result == false {
					hasMachine = true
				} else {
					ft.damagedMultipleMachines <- tempMultipleMachine
				}
			}
			fmt.Println("Need help with multipling")
			ft.waitingHelpMachineServer <- tempMultipleMachine
			tempMultipleMachine = <- ft.multipleMachineWithHelperServer
			fmt.Println("Gets help with machines!")
			tempMultipleMachine.SolveTask(tempProduct)
			ft.multipleMachineServer <- tempMultipleMachine
			ft.productServer <- tempProduct
			hasMachine = false
		}

		time.Sleep(time.Second * time.Duration(config.WorkersBreak))
	}
}

func (ft Factory)Bishop () {
	for {
		time.Sleep(time.Second * time.Duration(config.BishopBreak))
		tempProduct := <- ft.productServer
		fmt.Println("Bishop is on the way!")
		if tempProduct.Operator == 0 {
			ft.logistic.DeliveryOfSum(tempProduct)
		}
		if tempProduct.Operator == 1 {
			ft.logistic.DeliveryOfMinus(tempProduct)
		}
		if tempProduct.Operator == 2 {
			ft.logistic.DeliveryOfMultiply(tempProduct)
		}
	}
}

func (ft Factory)Handyman() {
	for {
		fmt.Println("Handyman is working ")
		if len(ft.damagedAddMachines) > 0 {
			tempAddMachine := <- ft.damagedAddMachines
			time.Sleep(time.Second * time.Duration(config.RepairTime))
			ft.addMachineServer <- tempAddMachine
		}
		if len(ft.damagedMinusMachines) > 0 {
			tempMinusMachine := <- ft.damagedMinusMachines
			time.Sleep(time.Second * time.Duration(config.RepairTime))
			ft.minusMachineServer <- tempMinusMachine
		}
		if len(ft.damagedMultipleMachines) > 0 {
			tempMultipleMachine := <- ft.damagedMultipleMachines
			time.Sleep(time.Second * time.Duration(config.RepairTime))
			ft.multipleMachineServer <- tempMultipleMachine
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

