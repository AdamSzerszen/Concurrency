with servers; use servers;
with collections; use collections;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Random_Seeds; use Random_Seeds;
with config; use config;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with machine_monitors; use machine_monitors;
with math_machines; use math_machines;
with Ada.Numerics.Discrete_Random;
package company is

   task type Chairman (taskServer : servers.TaskServerPointer);
   task type Worker (taskServer : servers.TaskServerPointer;
                     productServer : servers.TaskServerPointer;
                     unscheduledMultipleMachines : UnscheduledMultipleMachineMonitorPtr;
                     unscheduledAddMachines : UnscheduledAddMachineMonitorPtr;
                     unscheduledMinusMachines : UnscheduledMinusMachineMonitorPtr;
                     multipleMachinesWithTasks : MultipleMachineWithTasksMonitorPtr;
                     damagedMultipleMachines : DamagedMultipleMachineMonitorPtr;
                     damagedAddMachines : DamagedAddMachineMonitorPtr;
                     damagedMinusMachines : DamagedMinusMachineMonitorPtr;
                     number : Integer);
   task type Customer (productServer : servers.TaskServerPointer);
   task type Handyman (damagedMultipleMachines : DamagedMultipleMachineMonitorPtr;
                       damagedAddMachines : DamagedAddMachineMonitorPtr;
                       damagedMinusMachines : DamagedMinusMachineMonitorPtr;
                       unscheduledMultipleMachines : UnscheduledMultipleMachineMonitorPtr;
                       unscheduledAddMachines : UnscheduledAddMachineMonitorPtr;
                       unscheduledMinusMachines : UnscheduledMinusMachineMonitorPtr);
                       --task type TaxOffice (taskServer : servers.TaskServerPointer;
                       --                     productServer : servers.ProductServerPointer);

   procedure ScrewUpAdding(addMachine : in out AddMachinePtr);
   procedure ScrewUpMinusing(minusMachine : in out MinusMachinePtr);
   procedure ScrewUpMultippling(multipleMachine : in out MultipleMachinePtr);
end company;
