(* Author: Tjark Weber, Uppsala University
*)

section \<open>Translation of the IEEE model (with a single NaN value) into SMT-LIB's floating point theory\<close>

theory IEEE_Single_NaN_SMTLIB
  imports
    IEEE_Single_NaN
    keywords
    "flattening" :: diag
begin

text \<open>Mini version of sledgehammer. The builtin sledgehammer (HOL/Tools/Sledgehammer/) and SMT 
  (HOL/Tools/SMT/) code does not currently support dependent types. The code below serves, as of 
  now, as a tool to generate benchmarks for the upcoming SMT-LIB 3. Since declaring dependent types 
  requires fundamental changes in the source code, this provides full control of changes needed.\<close>

ML_file \<open>mchammer/mchammer_util.ML\<close>

ML_file \<open>mchammer_smt/mchammer_smt_util.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smt_config.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smt_builtin.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smt_normalize.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smt_datatypes.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smt_translate.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smtlib.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smtlib_interface.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smtlib_proof.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smtlib_real.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smt_solver.ML\<close>
ML_file \<open>mchammer_smt/mchammer_smt_systems.ML\<close>


ML_file \<open>mchammer/mchammer_fact.ML\<close>
ML_file \<open>mchammer/mchammer_flattener.ML\<close>
ML_file \<open>mchammer/mchammer_flattener_smt.ML\<close>
ML_file \<open>mchammer/mchammer.ML\<close>
ML_file \<open>mchammer/mchammer_commands.ML\<close>

ML_file \<open>mchammer/mirabelle_mchammer.ML\<close>
ML_file \<open>mchammer_smt_float.ML\<close>

text \<open>SMT setup. Note that an interpretation of floating-point arithmetic in SMT-LIB allows external
  SMT solvers that support the SMT-LIB floating-point theory to find more proofs, but---in the
  absence of built-in floating-point automation in Isabelle/HOL---significantly \emph{reduces}
  Sledgehammer's proof reconstruction rate. Until such automation becomes available, you probably
  want to use the interpreted translation only if you intend to use the external SMT solvers as
  trusted oracles.\<close>
end
