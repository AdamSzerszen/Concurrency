package math_machines

import (
	"collections"
	"config"
)

type AddMachine struct {
	HasTask bool
	IsDamaged bool
}

func (am *AddMachine) UseAsSolver(taskToSolve *collections.TaskToDo) {
	am.HasTask = true
	am.SolveTask(taskToSolve)
	am.HasTask = false
}

func (am *AddMachine) Repair() {
	am.IsDamaged = false
}

func (am *AddMachine) SolveTask(taskToSolve *collections.TaskToDo) {
	taskToSolve.Solution = taskToSolve.ParamA + taskToSolve.ParamB
}

func (am *AddMachine) Damage() {
	am.IsDamaged = true
}

func PrepareAddMachines () chan *AddMachine {
	addMachines := make(chan *AddMachine, config.NumberOfAddMachines)
	for i := 1; i <= config.NumberOfAddMachines; i++{
		tempMachine := new(AddMachine)
		tempMachine.IsDamaged = false
		tempMachine.HasTask = false
		addMachines <- tempMachine
	}
	return addMachines
}
