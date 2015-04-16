with Ada.Containers.Vectors;
with config; use config;
with math_machines; use math_machines;
with Ada.Text_IO; use Ada.Text_IO;

package machine_monitors is

   package MultipleVector is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => MultipleMachinePtr);

   package AddVector is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => AddMachinePtr);

   package MinusVector is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => MinusMachinePtr);

   type boolPtr is access Boolean;

   task type UnscheduledAddMachineMonitor is
      entry UseAsSolver (machineToSolve : in out AddMachinePtr);
      entry LeaveAsSolver (machineToLeave : in out AddMachinePtr);
   end UnscheduledAddMachineMonitor;
   type UnscheduledAddMachineMonitorPtr is
     access UnscheduledAddMachineMonitor;

   task type UnscheduledMinusMachineMonitor is
      entry UseAsSolver (machineToSolve : in out MinusMachinePtr);
      entry LeaveAsSolver (machineToLeave : in out MinusMachinePtr);
   end UnscheduledMinusMachineMonitor;
   type UnscheduledMinusMachineMonitorPtr is
     access UnscheduledMinusMachineMonitor;

   task type UnscheduledMultipleMachineMonitor is
      entry UseAsSolver (machineToSolve : in out MultipleMachinePtr);
      entry LeaveAsSolver (machineToLeave : in out MultipleMachinePtr);
   end UnscheduledMultipleMachineMonitor;
   type UnscheduledMultipleMachineMonitorPtr is
     access UnscheduledMultipleMachineMonitor;

   task type MultipleMachineWithTasksMonitor is
      entry NeedHelp (answer : in out boolPtr);
      entry AskForHelp (machineToHelp : in out MultipleMachinePtr);
      entry UseAsHelper (machineToHelp : in out MultipleMachinePtr);
      entry LeaveAsHelper (machineToLeave : in out MultipleMachinePtr);
   end MultipleMachineWithTasksMonitor;
   type MultipleMachineWithTasksMonitorPtr is
     access MultipleMachineWithTasksMonitor;

   task type DamagedMultipleMachineMonitor is
      entry ApplyDamagedMachine (damagedMachine : in out MultipleMachinePtr);
      entry Repair(unscheduledMachines : in out UnscheduledMultipleMachineMonitorPtr);
   end DamagedMultipleMachineMonitor;
   type DamagedMultipleMachineMonitorPtr is
     access DamagedMultipleMachineMonitor;

   task type DamagedAddMachineMonitor is
      entry ApplyDamagedMachine (damagedMachine : in out AddMachinePtr);
      entry Repair(unscheduledMachines : in out UnscheduledAddMachineMonitorPtr);
   end DamagedAddMachineMonitor;
   type DamagedAddMachineMonitorPtr is
     access DamagedAddMachineMonitor;

   task type DamagedMinusMachineMonitor is
      entry ApplyDamagedMachine (damagedMachine : in out MinusMachinePtr);
      entry Repair(unscheduledMachines : in out UnscheduledMinusMachineMonitorPtr);
   end DamagedMinusMachineMonitor;
   type DamagedMinusMachineMonitorPtr is
     access DamagedMinusMachineMonitor;

end machine_monitors;
