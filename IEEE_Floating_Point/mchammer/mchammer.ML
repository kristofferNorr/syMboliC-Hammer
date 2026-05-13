(*  Title:      
    Author:     Kristoffer Norrman


*)

signature MCHAMMER =
sig
  type stature = ATP_Problem_Generate.stature
  type fact = MCHammer_Fact.fact
  type mode = MCHammer_Flattener.mode
  type params = MCHammer_Flattener.params
  type flattener = MCHammer_Flattener.flattener
  type flattener_result = MCHammer_Flattener.flattener_result

  datatype mchammer_outcome = 
    SH_Some of flattener_result
  | SH_Unknown
  | SH_Timeout
  | SH_ResourcesOut
  | SH_None
  
  val short_string_of_mchammer_outcome : mchammer_outcome -> string
  val mchammer_run : params -> mode -> (string -> unit) option -> int -> Proof.state -> 
        bool * (mchammer_outcome * string)
end;

structure MCHammer : MCHAMMER =
struct

type stature = ATP_Problem_Generate.stature
type fact = MCHammer_Fact.fact
type mode = MCHammer_Flattener.mode
type params = MCHammer_Flattener.params

type flattener = MCHammer_Flattener.flattener

type flattener_result = MCHammer_Flattener.flattener_result

datatype mchammer_outcome = 
    SH_Some of flattener_result
  | SH_Unknown
  | SH_Timeout
  | SH_ResourcesOut
  | SH_None

fun short_string_of_mchammer_outcome (SH_Some _) = "some"
  | short_string_of_mchammer_outcome SH_Unknown = "unknown"
  | short_string_of_mchammer_outcome SH_TimeOut = "timeout"
  | short_string_of_mchammer_outcome SH_ResourcesOut = "resources_out"
  | short_string_of_mchammer_outcome SH_None = "none"

fun get_flattener name = MCHammer_Flattener_SMT.run_smt_flattener name

fun fact_count facts = Facts.fold_static (K (Integer.add 1)) facts 0

fun mchammer_run (params as {induction_rules, max_facts,...}) mode writeln_result i state = 
  case MCHammer_Util.subgoal_count state of
    0 => (error "No subgoals")
  | n =>  
    let   
      val print = if mode = MCHammer_Flattener.Normal andalso is_none writeln_result then writeln else K ()

      val ctxt = Proof.context_of state
      val inst_inducts = induction_rules = SOME MCHammer_Flattener.Instantiate
      val {facts = chained_thms, goal, ...} = Proof.goal state
      val (_, hyp_ts, concl_t) = ATP_Util.strip_subgoal goal i ctxt
      val fact_override = {add = [], del = [], only = false}

      val _ = print "Flattening..."
      val ({elapsed,...}, all_facts) = Timing.timing (MCHammer_Fact.nearly_all_facts_of_context
            ctxt inst_inducts fact_override chained_thms hyp_ts) concl_t
      
      val problem = 
        {comment = "Flabelle_Flattener.problem #comment", state = state, goal = goal, subgoal = i, subgoal_count = n, 
          factss = []}
      val result = SH_Some (get_flattener "Test" params problem)
    in
      (true, (result, "TODO: add results when more integrated."))
    end
end;