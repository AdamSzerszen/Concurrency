package main

import (
	"collections"
	"company"
	"config"
	"math_machines"
	"fmt"
	"time"
)

func main() {
	exitChanel := make(chan int)
	tasks := collections.TaskServer()
	products := collections.ProductServer()
	addMachines := math_machines.PrepareAddMachines()
	minusMachines := math_machines.PrepareMinusMachines()
	multipleMachines := math_machines.PrepareMultipleMachines()
	waitingMultipleMachines := make(chan *math_machines.MultipleMachine, config.NumberOfMultipleMachines)
	multipleMachinesWithHelpers := make(chan *math_machines.MultipleMachine)
	damagedAddMachines := make(chan *math_machines.AddMachine, config.NumberOfAddMachines)
	damagedMinusMachines := make(chan *math_machines.MinusMachine, config.NumberOfMinusMachines)
	damagedMultipleMachines := make(chan *math_machines.MultipleMachine, config.NumberOfMultipleMachines)
	go company.Chairman(tasks)
	go company.Customer(products)
	go company.Handyman(addMachines, minusMachines, multipleMachines,
		damagedAddMachines, damagedMinusMachines, damagedMultipleMachines)
	for i := 1; i <= config.NumberOfWorkers; i++ {
		if config.CompanyTalkative {
			fmt.Print("Worker number ")
			fmt.Print(i)
			fmt.Println(" started his day!")
		}
		go company.Worker(tasks, products, addMachines,
			minusMachines, multipleMachines, waitingMultipleMachines, multipleMachinesWithHelpers, damagedAddMachines,
			damagedMinusMachines, damagedMultipleMachines, i)
		time.Sleep(time.Second * time.Duration(config.WorkerEmploymentTime))
	}
	<-exitChanel
}
