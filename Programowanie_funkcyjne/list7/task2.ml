(* Slawomir Gorawski *)

module type VERTEX =
  sig
    type t
    type label

    val equal : t -> t -> bool
    val create : label -> t
    val label : t -> label
  end

module type EDGE =
  sig
    type t
    type label
    type vertex

    val equal : t -> t -> bool
    val create : vertex -> vertex -> label -> t
    val label : t -> label
    val beg_v : t -> vertex
    val end_v : t -> vertex
  end

module Vertex : (VERTEX with type label = int) = struct
  type label = int
  type t = label

  let equal v1 v2 = v1 = v2

  let create l = l

  let label v = v
end

module Edge : (EDGE with type vertex = Vertex.t and type label = int) = struct
  type label = int
  type vertex = Vertex.t
  type t = vertex * label * vertex

  let equal e1 e2 = e1 = e2

  let create v1 v2 l = (v1, l, v2)

  let label (_, l, _) = l

  let beg_v (v, _, _) = v

  let end_v (_, _, v) = v
end

module type GRAPH =
  sig
    (* typ reprezentacji grafu *)
    type t

    module V : VERTEX
    type vertex = V.t

    module E : (EDGE with type vertex = vertex)

    type edge = E.t

    (* funkcje wyszukiwania *)
    val mem_v : t -> vertex -> bool
    val mem_e : t -> edge -> bool
    val mem_e_v : t -> vertex -> vertex -> bool
    val find_e : t -> vertex -> vertex -> edge
    val succ : t -> vertex -> vertex list
    val pred : t -> vertex -> vertex list
    val succ_e : t -> vertex -> edge list
    val pred_e : t -> vertex -> edge list

    (* funkcje modyfikacji *)
    val empty : t
    val add_e : t -> edge -> t
    val add_v : t -> vertex -> t
    val rem_e : t -> edge -> t
    val rem_v : t -> vertex -> t

    (* iteratory *)
    val fold_v : ( vertex -> 'a -> 'a ) -> t -> 'a -> 'a
    val fold_e : ( edge -> 'a -> 'a ) -> t -> 'a -> 'a
  end

module MakeGraph (V : VERTEX) (E : EDGE with type vertex = V.t)
    : (GRAPH with module V = V and module E = E) = struct
  module V = V
  type vertex = V.t

  module E = E
  type edge = E.t

  type t = (vertex list) * (edge list)

  let mem_v g v = List.exists (V.equal v) (fst g)

  let mem_e g e = List.exists (E.equal e) (snd g)

  let mem_e_v g v1 v2 =
    List.exists
    (fun e -> V.equal (E.beg_v e) v1 && V.equal (E.end_v e) v2)
    (snd g)
  
  let find_e g v1 v2 =
    List.find
    (fun e -> V.equal (E.beg_v e) v1 && V.equal (E.end_v e) v2)
    (snd g)
  
  let succ g v = []

  let pred g v = []

  let succ_e g v = List.filter (fun e -> V.equal (E.beg_v e) v) (snd g)

  let pred_e g v = List.filter (fun e -> V.equal (E.end_v e) v) (snd g)

  let empty = ([], [])

  let add_v g v = if mem_v g v then g else (v :: fst g, snd g)

  let add_e g e =
    if mem_e g e then g else
    (fst g, e :: snd g)
    |> fun g -> add_v g (E.beg_v e)
    |> fun g -> add_v g (E.end_v e)

  let rem_e g e = (fst g, List.filter (fun e' -> not @@ E.equal e' e) (snd g))

  let rem_v g v =
    ( List.filter (fun v' -> not @@ V.equal v' v) (fst g)
    , List.filter
      (fun e -> not (V.equal (E.beg_v e) v) && not (V.equal (E.end_v e) v))
      (snd g)
    )
  
  let fold_v f g c = List.fold_right f (fst g) c

  let fold_e f g c = List.fold_right f (snd g) c
end
