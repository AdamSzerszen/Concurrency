package math_machines

import (
	"collections"
	"config"
)

type MultipleMachine struct {
	HasTask bool
	IsDamaged bool
}

func (am *MultipleMachine) UseAsSolver(taskToSolve *collections.TaskToDo) {
	am.HasTask = true
	am.SolveTask(taskToSolve)
	am.HasTask = false
}

func (am *MultipleMachine) Repair() {
	am.IsDamaged = false
}

func (am *MultipleMachine) SolveTask(taskToSolve *collections.TaskToDo) {
	taskToSolve.Solution = taskToSolve.ParamA * taskToSolve.ParamB
}

func (am *MultipleMachine) Damage() {
	am.IsDamaged = true
}

func PrepareMultipleMachines () chan *MultipleMachine {
	multipleMachines := make(chan *MultipleMachine, config.NumberOfMultipleMachines)
	for i := 1; i <= config.NumberOfMultipleMachines; i++{
		tempMachine := new(MultipleMachine)
		tempMachine.IsDamaged = false
		tempMachine.HasTask = false
		multipleMachines <- tempMachine
	}
	return multipleMachines
}
