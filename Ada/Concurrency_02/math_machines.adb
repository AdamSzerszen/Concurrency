package body math_machines is

   protected body MultipleMachine is
      procedure UseAsSolver (taskToSolve : TaskPointer) is
      begin
         Put_Line("Machine body (entry useassolver)");
         HasTask := True;
         if HasHelper /= True then
            Wait;
         end if;
         SolveTask(taskToSolve);
         HasTask := False;
      end UseAsSolver;

      entry UseAsHelper
         when True is
      begin
         HasHelper := True;
         Put_Line("Helping!");
         delay 3.0;
         HasHelper := False;
      end UseAsHelper;

      entry Wait
        when HasHelper = False is
      begin
         Put_Line("Waiting for helper!");
         requeue UseAsHelper;
      end Wait;

      procedure Damage is
      begin
         IsDamaged := True;
      end Damage;

      entry Repair
        when IsDamaged = True is
      begin
         delay 5.0;
         IsDamaged := False;
      end Repair;

      procedure SolveTask(taskToSolve : TaskPointer) is
      begin
         delay 2.0;
         taskToSolve.Solution := taskToSolve.ParamA * taskToSolve.ParamB;
      end SolveTask;

      function isDamage return Boolean is
      begin
         return IsDamaged;
      end isDamaged;
   end MultipleMachine;

   protected body AddMachine is
      procedure UseAsSolver (taskToSolve : TaskPointer) is
      begin
         Put_Line("Machine body (entry useassolver)");
         HasTask := True;
         SolveTask(taskToSolve);
         HasTask := False;
      end UseAsSolver;

      procedure Repair is
      begin
         delay 5.0;
         IsDamaged := False;
      end Repair;

      procedure SolveTask(taskToSolve : TaskPointer) is
      begin
         Put_Line("Solving procedure");
         delay 2.0;
         taskToSolve.Solution := taskToSolve.ParamA + taskToSolve.ParamB;
      end SolveTask;

      procedure Damage is
      begin
         IsDamaged := True;
      end Damage;

      function isDamage return Boolean is
      begin
         return IsDamaged;
      end isDamaged;
   end AddMachine;

   protected body MinusMachine is
      entry UseAsSolver(taskToSolve : TaskPointer)
        when HasTask = False is
      begin
         Put_Line("Machine body (entry useassolver)");
         HasTask := True;
         SolveTask(taskToSolve);
         HasTask := False;
      end UseAsSolver;

      entry Repair
        when IsDamaged = True is
      begin
         delay 5.0;
         IsDamaged := False;
      end Repair;

      procedure SolveTask(taskToSolve : TaskPointer) is
      begin
         Put_Line("Solving procedure");
         delay 2.0;
         taskToSolve.Solution := taskToSolve.ParamA - taskToSolve.ParamB;
      end SolveTask;

      procedure Damage is
      begin
         IsDamaged := True;
      end Damage;

      function isDamage return Boolean is
      begin
         return IsDamaged;
      end isDamaged;
   end MinusMachine;

end math_machines;
