package body machine_monitors is

   task body UnscheduledMultipleMachineMonitor is

      unscheduledMachines : MultipleVector.Vector;
      numberOfUnscheduledMachines : Integer := config.NumberOfMultipleMachines;
      tempMultipleMachine : MultipleMachinePtr;
   begin
       MultipleVector.Insert(Container => unscheduledMachines,
                       Before    => 1,
                             New_Item  => new MultipleMachine);
      numberOfUnscheduledMachines := 1;
      loop
         select
            when numberOfUnscheduledMachines > 0 =>
               accept UseAsSolver (machineToSolve : in out MultipleMachinePtr) do
                   Put_Line("Using multiple machine!");
                  tempMultipleMachine :=
                    MultipleVector.Element(MultipleVector.Last(
                                           Container => unscheduledMachines));
                  MultipleVector.Delete_Last(Container => unscheduledMachines);
                  machineToSolve := tempMultipleMachine;
                  numberOfUnscheduledMachines := numberOfUnscheduledMachines - 1;
               end UseAsSolver;
         or
            accept LeaveAsSolver (machineToLeave : in out MultipleMachinePtr) do
               MultipleVector.Insert(Container => unscheduledMachines,
                                 Before    => 1,
                                     New_Item  => machineToLeave);
               Put_Line("Leaving add machine");
               numberOfUnscheduledMachines := numberOfUnscheduledMachines + 1;
            end LeaveAsSolver;
         end select;
      end loop;
   end UnscheduledMultipleMachineMonitor;

   task body UnscheduledAddMachineMonitor is
      unscheduledMachines : AddVector.Vector;
      numberOfUnscheduledMachines : Integer := config.NumberOfAddMachines;
      tempAddMachine : AddMachinePtr;
   begin
      AddVector.Insert(Container => unscheduledMachines,
                       Before    => 1,
                       New_Item  => new AddMachine);
      loop
         select
            when numberOfUnscheduledMachines > 0 =>
               accept UseAsSolver (machineToSolve : in out AddMachinePtr) do
                  Put_Line("Using add machine!");
                  tempAddMachine :=
                    AddVector.Element(AddVector.Last(
                                           Container => unscheduledMachines));
                  AddVector.Delete_Last(Container => unscheduledMachines);
                  machineToSolve := tempAddMachine;
                  numberOfUnscheduledMachines := numberOfUnscheduledMachines - 1;
               end UseAsSolver;
         or
            accept LeaveAsSolver (machineToLeave : in out AddMachinePtr) do
               Put_Line("Leaving add machine");
               AddVector.Insert(Container => unscheduledMachines,
                                 Before    => 1,
                                 New_Item  => machineToLeave);
               numberOfUnscheduledMachines := numberOfUnscheduledMachines + 1;
            end LeaveAsSolver;
         end select;
      end loop;
   end UnscheduledAddMachineMonitor;

   task body UnscheduledMinusMachineMonitor is
      unscheduledMachines : MinusVector.Vector;
      numberOfUnscheduledMachines : Integer := config.NumberOfMinusMachines;
      tempMinusMachine : MinusMachinePtr;
   begin
      MinusVector.Insert(Container => unscheduledMachines,
                       Before    => 1,
                       New_Item  => new MinusMachine);
      loop
         select
            when numberOfUnscheduledMachines > 0 =>
               accept UseAsSolver (machineToSolve : in out MinusMachinePtr) do
                  tempMinusMachine :=
                    MinusVector.Element(MinusVector.Last(
                                      Container => unscheduledMachines));
                  MinusVector.Delete_Last(Container => unscheduledMachines);
                  machineToSolve := tempMinusMachine;
                  numberOfUnscheduledMachines := numberOfUnscheduledMachines - 1;
               end UseAsSolver;
         or
            accept LeaveAsSolver (machineToLeave : in out MinusMachinePtr) do
               MinusVector.Insert(Container => unscheduledMachines,
                                Before    => 1,
                                New_Item  => machineToLeave);
               numberOfUnscheduledMachines := numberOfUnscheduledMachines + 1;
            end LeaveAsSolver;
         end select;
      end loop;
   end UnscheduledMinusMachineMonitor;

   task body MultipleMachineWithTasksMonitor is

      machinesWithTasks : MultipleVector.Vector;
      numberOfMachinesWithTasks : Integer := 0;
      tempMultipleMachine : MultipleMachinePtr;
   begin
      loop
         select
            accept NeedHelp (answer : in out boolPtr) do
               if numberOfMachinesWithTasks > 0 then
                  answer.All := True;
               else
                  answer.All := False;
               end if;
            end NeedHelp;
         or
            accept AskForHelp (machineToHelp : in out MultipleMachinePtr) do
               MultipleVector.Insert(Container => machinesWithTasks,
                                 Before    => 1,
                                 New_Item  => machineToHelp);
               numberOfMachinesWithTasks := numberOfMachinesWithTasks + 1;
            end AskForHelp;
         or
           -- when numberOfMachinesWithTasks > 0 =>
               accept UseAsHelper (machineToHelp : in out MultipleMachinePtr) do
                  tempMultipleMachine :=
                    MultipleVector.Element(MultipleVector.Last(
                                           Container => machinesWithTasks));
                  MultipleVector.Delete_Last(Container => machinesWithTasks);
                  machineToHelp := tempMultipleMachine;
                  numberOfMachinesWithTasks := numberOfMachinesWithTasks - 1;
               end UseAsHelper;
         or
            accept LeaveAsHelper (machineToLeave : in out MultipleMachinePtr) do
               MultipleVector.Insert(Container => machinesWithTasks,
                                 Before    => 1,
                                 New_Item  => machineToLeave);
               numberOfMachinesWithTasks := numberOfMachinesWithTasks + 1;
            end LeaveAsHelper;
         end  select;
      end loop;
   end MultipleMachineWithTasksMonitor;

   task body DamagedMultipleMachineMonitor is
      damagedMachines : MultipleVector.Vector;
      numberOfDamagedMachines : Integer := 0;
      tempMachine : MultipleMachinePtr;
   begin
      loop
         select
            accept ApplyDamagedMachine (damagedMachine : in MultipleMachinePtr) do
               MultipleVector.Insert(Container => damagedMachines,
                                    Before    => 1,
                                    New_Item  => damagedMachine);
               numberOfDamagedMachines := numberOfDamagedMachines + 1;
            end ApplyDamagedMachine;
         or
            when numberOfDamagedMachines > 0 =>
               accept Repair (unscheduledMachines : in out UnscheduledMultipleMachineMonitorPtr) do
               for i  in 1 .. numberOfDamagedMachines loop
                     tempMachine := MultipleVector.Element(Container => damagedMachines,
                                                           Index     => i);
                     tempMachine.Repair;
                     unscheduledMachines.LeaveAsSolver(tempMachine);
                  end loop;
                  MultipleVector.Clear(Container => damagedMachines);
                  numberOfDamagedMachines := 0;
               end Repair;
         end select;
      end loop;
   end DamagedMultipleMachineMonitor;

   task body DamagedAddMachineMonitor is
      damagedMachines : AddVector.Vector;
      numberOfDamagedMachines : Integer := 0;
      tempMachine : AddMachinePtr;
   begin
      loop
         select
            accept ApplyDamagedMachine (damagedMachine : in AddMachinePtr) do
               AddVector.Insert(Container => damagedMachines,
                                    Before    => 1,
                                    New_Item  => damagedMachine);
               numberOfDamagedMachines := numberOfDamagedMachines + 1;
            end ApplyDamagedMachine;
         or
            when numberOfDamagedMachines > 0 =>
               accept Repair (unscheduledMachines : in out UnscheduledAddMachineMonitorPtr) do
                  for i  in 1 .. numberOfDamagedMachines loop
                     tempMachine := AddVector.Element(Container => damagedMachines,
                                                      Index     => i);
                     tempMachine.Repair;
                     unscheduledMachines.LeaveAsSolver(tempMachine);
                  end loop;
                  AddVector.Clear(Container => damagedMachines);
                  numberOfDamagedMachines := 0;
               end Repair;
         end select;
      end loop;
   end DamagedAddMachineMonitor;

   task body DamagedMinusMachineMonitor is
      damagedMachines : MinusVector.Vector;
      numberOfDamagedMachines : Integer := 0;
      tempMachine : MinusMachinePtr;
   begin
      loop
         select
            accept ApplyDamagedMachine (damagedMachine : in MinusMachinePtr) do
               MinusVector.Insert(Container => damagedMachines,
                                    Before    => 1,
                                    New_Item  => damagedMachine);
               numberOfDamagedMachines := numberOfDamagedMachines + 1;
            end ApplyDamagedMachine;
         or
            when numberOfDamagedMachines > 0 =>
               accept Repair (unscheduledMachines : in out UnscheduledMinusMachineMonitorPtr) do
               for i  in 1 .. numberOfDamagedMachines loop
                     tempMachine := MinusVector.Element(Container => damagedMachines,
                                                           Index     => i);
                     tempMachine.Repair;
                     unscheduledMachines.LeaveAsSolver(tempMachine);
                  end loop;
                  MinusVector.Clear(Container => damagedMachines);
                  numberOfDamagedMachines := 0;
               end Repair;
         end select;
      end loop;
   end DamagedMinusMachineMonitor;
end machine_monitors;
