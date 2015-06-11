package factories

import (
	"companies"
	"collections"
	"math_machines"
	"config"
	"fmt"
)

type Factory struct {
	logistic *companies.LogisticCompany
	productServer chan *collections.TaskToDo
	taskServer chan *collections.TaskToDo
	addMachineServer chan *math_machines.AddMachine
	minusMachineServer chan *math_machines.MinusMachine
	multipleMachineServer chan *math_machines.MultipleMachine
	waitingHelpMachineServer chan *math_machines.MultipleMachine
	multipleMachineWithHelperServer chan *math_machines.MultipleMachine
	damagedAddMachines chan *math_machines.AddMachine
	damagedMinusMachines chan *math_machines.MinusMachine
	damagedMultipleMachines chan *math_machines.MultipleMachine
}

func CreateFactory(logistic *companies.LogisticCompany) *Factory {
	tempFactory := new(Factory)
	tempFactory.logistic = logistic
	tempFactory.productServer = make(chan *collections.TaskToDo, config.MaximalProductVectorSize)
	tempFactory.taskServer = make(chan *collections.TaskToDo, config.MaximalTaskVectorSize)
	tempFactory.addMachineServer = make(chan *math_machines.AddMachine, config.NumberOfAddMachines)
	tempFactory.minusMachineServer = make(chan *math_machines.MinusMachine, config.NumberOfMinusMachines)
	tempFactory.multipleMachineServer = make(chan *math_machines.MultipleMachine, config.NumberOfMultipleMachines)
	tempFactory.waitingHelpMachineServer = make(chan *math_machines.MultipleMachine, config.NumberOfMultipleMachines)
	tempFactory.multipleMachineWithHelperServer = make(chan *math_machines.MultipleMachine, config.NumberOfMultipleMachines)
	tempFactory.damagedAddMachines = make(chan *math_machines.AddMachine, config.NumberOfAddMachines)
	tempFactory.damagedMinusMachines = make(chan *math_machines.MinusMachine, config.NumberOfMinusMachines)
	tempFactory.damagedMultipleMachines = make(chan *math_machines.MultipleMachine, config.NumberOfMultipleMachines)
	return tempFactory
}

func (ft Factory) Start() {
	fmt.Println("Factory started working!")
	ft.addMachineServer = math_machines.PrepareAddMachines()
	ft.minusMachineServer = math_machines.PrepareMinusMachines()
	ft.multipleMachineServer = math_machines.PrepareMultipleMachines()
	go ft.Chairman()
	for i := 0; i < config.NumberOfWorkers; i++{
		go ft.Worker()
	}
	for i := 0; i < config.NumberOfBishops; i++ {
		go ft.Bishop()
	}
	go ft.Handyman()
}

func (ft Factory) SendSumProduct(product *collections.TaskToDo) {
	fmt.Println("Factory is sending supplies")
	ft.logistic.DeliveryOfSum(product)
}

func (ft Factory) SendMinusProduct(product *collections.TaskToDo) {
	fmt.Println("Factory is sending supplies")
	ft.logistic.DeliveryOfMinus(product)
}

func (ft Factory) SendMultiplyProduct(product *collections.TaskToDo) {
	fmt.Println("Factory is sending supplies")
	ft.logistic.DeliveryOfMultiply(product)
}

