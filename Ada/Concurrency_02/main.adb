with servers; use servers;
with company; use company;
with machine_monitors; use machine_monitors;
with config; use config;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   taskServerPointer : servers.TaskServerPointer := new servers.TaskServer;
   productServerPointer : servers.TaskServerPointer := new servers.TaskServer;
   unscheduledAddMachineMonitor : machine_monitors.UnscheduledAddMachineMonitorPtr
     := new machine_monitors.UnscheduledAddMachineMonitor;
   unscheduledMinusMachineMonitor : machine_monitors.UnscheduledMinusMachineMonitorPtr
     := new machine_monitors.UnscheduledMinusMachineMonitor;
   unscheduledMultipleMachineMonitor : machine_monitors.UnscheduledMultipleMachineMonitorPtr
     := new machine_monitors.UnscheduledMultipleMachineMonitor;
   multipleMachinesWithTasks : machine_monitors.MultipleMachineWithTasksMonitorPtr
     := new machine_monitors.MultipleMachineWithTasksMonitor;
   damagedAddMachineMonitor : machine_monitors.DamagedAddMachineMonitorPtr
     := new machine_monitors.DamagedAddMachineMonitor;
   damageMinusMachineMonitor : machine_monitors.DamagedMinusMachineMonitorPtr
     := new machine_monitors.DamagedMinusMachineMonitor;
   damageMultipleMachineMonitor : machine_monitors.DamagedMultipleMachineMonitorPtr
     := new machine_monitors.DamagedMultipleMachineMonitor;
   chairman : company.Chairman(taskServerPointer);
   type workerPointer  is access company.Worker;
   workers : array(1..NumberOfWorkers) of workerPointer;
   type customerPointer is access company.Customer;
   customers : array(1..NumberOfCustomers) of customerPointer;
   handyman : company.Handyman(damageMultipleMachineMonitor,
                               damagedAddMachineMonitor,
                               damageMinusMachineMonitor,
                               unscheduledMultipleMachineMonitor,
                               unscheduledAddMachineMonitor,
                               unscheduledMinusMachineMonitor);
   customerCounter : Integer := 0;
begin
   for i in 1..NumberOfWorkers loop
      workers(i) := new company.Worker(taskServerPointer,
                                       productServerPointer,
                                       unscheduledMultipleMachineMonitor,
                                       unscheduledAddMachineMonitor,
                                       unscheduledMinusMachineMonitor,
                                       multipleMachinesWithTasks,
                                       damageMultipleMachineMonitor,
                                       damagedAddMachineMonitor,
                                       damageMinusMachineMonitor,
                                       i);

      if customerCounter < NumberOfCustomers then
         customers(i) := new company.Customer(productServerPointer);
         customerCounter := customerCounter + 1;
      end if;
      if CompanyTalkative then
         Put("Worker number ");
         Put(Integer'Image(i));
         Put_Line(" started his day!");
      end if;
      delay WorkerEmploymentTime;
   end loop;
end Main;
