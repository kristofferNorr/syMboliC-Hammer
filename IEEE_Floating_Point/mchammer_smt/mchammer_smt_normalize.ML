(*  Title:      
    Author:     Kristoffer Norrman


*)

signature MCHAMMER_SMT_NORMALIZE =
sig
  
  (** atomization **)
  val atomize_conv: Proof.context -> conv

  val normalize: Proof.context -> (MCHammer_SMT_Util.role * thm) list -> ((int * MCHammer_SMT_Util.role) * thm) list   

end;

structure MCHammer_SMT_Normalize : MCHAMMER_SMT_NORMALIZE =
struct



(** normalize definitions **)

fun norm_def thm =
  (case Thm.prop_of thm of
    \<^Const_>\<open>Trueprop for \<^Const>\<open>HOL.eq _ for _ \<open>Abs _\<close>\<close>\<close> => norm_def (thm RS @{thm fun_cong})
  | \<^Const_>\<open>Pure.eq _ for _ \<open>Abs _\<close>\<close> => norm_def (HOLogic.mk_obj_eq thm)
  | _ => thm)


(** atomization **)

fun atomize_conv ctxt ct =
  (case Thm.term_of ct of
    \<^Const_>\<open>Pure.imp for _ _\<close> =>
      Conv.binop_conv (atomize_conv ctxt) then_conv Conv.rewr_conv @{thm atomize_imp}
  | \<^Const_>\<open>Pure.eq _ for _ _\<close> =>
      Conv.binop_conv (atomize_conv ctxt) then_conv Conv.rewr_conv @{thm atomize_eq}
  | \<^Const_>\<open>Pure.all _ for \<open>Abs _\<close>\<close> =>
      Conv.binder_conv (atomize_conv o snd) ctxt then_conv Conv.rewr_conv @{thm atomize_all}
  | _ => Conv.all_conv) ct
  handle CTERM _ => Conv.all_conv ct



(** trigger inference **)
\<comment> \<open>TODO: add trigger inference; these are the quantifier triggers used in smt (:pattern) .\<close>


fun normalize ctxt wthms =
  wthms
  |> map_index (fn (n, (role, thm)) => ((n, role), thm))

(* setup normalization *)

end;