with collections; use collections;
with config; use config;
with Ada.Text_IO; use Ada.Text_IO;

package servers is

   task type TaskServer is
      entry AddTask (taskToAdd : in TaskPointer);
      entry PopTask (popedTask : in out TaskPointer);
   end TaskServer;

   type TaskServerPointer is access TaskServer;

end servers;
