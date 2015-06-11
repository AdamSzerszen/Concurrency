package math_machines

import (
	"collections"
	"config"
)

type MinusMachine struct {
	HasTask bool
	IsDamaged bool
}

func (am *MinusMachine) UseAsSolver(taskToSolve *collections.TaskToDo) {
	am.HasTask = true
	am.SolveTask(taskToSolve)
	am.HasTask = false
}

func (am *MinusMachine) Repair() {
	am.IsDamaged = false
}

func (am *MinusMachine) SolveTask(taskToSolve *collections.TaskToDo) {
	taskToSolve.Solution = taskToSolve.ParamA - taskToSolve.ParamB
}

func (am *MinusMachine) Damage() {
	am.IsDamaged = true
}

func PrepareMinusMachines () chan *MinusMachine {
	minusMachines := make(chan *MinusMachine, config.NumberOfMinusMachines)
	for i := 1; i <= config.NumberOfMinusMachines; i++{
		tempMachine := new(MinusMachine)
		tempMachine.IsDamaged = false
		tempMachine.HasTask = false
		minusMachines <- tempMachine
	}
	return minusMachines
}


