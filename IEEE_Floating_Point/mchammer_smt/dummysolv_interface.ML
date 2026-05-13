(*  Title:      
    Author:    

Dummy interface, based on HOL/Tools/SMT/z3_interface.ML.
*)


signature DUMMYSOLV_INTERFACE =
sig
  val smtlib_dummyC: MCHammer_SMT_Util.class
end;

structure DummySolv_Interface: DUMMYSOLV_INTERFACE =
struct

val dummyC = ["dummy3"]

val smtlib_dummyC = MCHammer_SMTLIB_Interface.smtlibC @ dummyC


(* interface *)

local
  fun translate_config ctxt =
    {order = MCHammer_SMT_Util.First_Order,
     logic = K (K ""),
     fp_kinds = [BNF_Util.Least_FP], 
     serialize = #serialize (MCHammer_SMTLIB_Interface.translate_config MCHammer_SMT_Util.First_Order ctxt)}

  val setup_builtins =
    SMT_Builtin.add_builtin_fun' smtlib_dummyC (\<^Const>\<open>times \<^Type>\<open>int\<close>\<close>, "*") 
in

val _ = Theory.setup (Context.theory_map (
  setup_builtins #>
  MCHammer_SMT_Translate.add_config (smtlib_dummyC, translate_config)))

end


(* constructors *)


(** additional constructors **)




(** basic and additional constructors **)



(* abstraction *)

end;
