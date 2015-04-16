with collections; use collections;
with Ada.Text_IO; use Ada.Text_IO;

package math_machines is

   protected type MultipleMachine is
      procedure UseAsSolver(taskToSolve : TaskPointer);
      entry UseAsHelper;
      entry Repair;
      procedure SolveTask(taskToSolve : TaskPointer);
      procedure Damage;
      function isDamage return Boolean;
   private
      entry Wait;
      HasTask : Boolean;
      HasHelper : Boolean;
      IsDamaged : Boolean := False;
   end MultipleMachine;
   type MultipleMachinePtr is access MultipleMachine;

   protected type AddMachine is
      procedure UseAsSolver(taskToSolve : TaskPointer);
      procedure Repair;
      procedure SolveTask(taskToSolve : TaskPointer);
      procedure Damage;
      function isDamage return Boolean;
   private
      HasTask : Boolean := False;
      IsDamaged : Boolean := False;
   end AddMachine;
   type AddMachinePtr is access AddMachine;

   protected type MinusMachine is
      entry UseAsSolver(taskToSolve : TaskPointer);
      entry Repair;
      procedure SolveTask(taskToSolve : TaskPointer);
      procedure Damage;
      function isDamage return Boolean;
   private
      HasTask : Boolean;
      IsDamaged : Boolean := False;
   end MinusMachine;
   type MinusMachinePtr is access MinusMachine;

end math_machines;
