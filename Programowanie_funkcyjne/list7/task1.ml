(* Slawomir Gorawski *)

module type ORDTYPE =
  sig
    type t
    type comparison = LT | EQ | GT
    
    val compare : t -> t -> comparison
  end

module type PQUEUE =
  sig
    type priority
    type 'a t

    exception EmptyPQueue

    val empty : 'a t
    val insert : 'a t -> priority -> 'a -> 'a t
    val remove : 'a t -> priority * 'a * 'a t
  end

module MakePQueue (OrdType : ORDTYPE) : (PQUEUE with type priority = OrdType.t) = struct

  type priority = OrdType.t

  type 'a t = (priority * 'a) list

  exception EmptyPQueue

  let empty = []
  
  let rec insert pq p x =
    match pq with
    | [] -> [(p, x)]
    | (p', x') :: tl ->
        if OrdType.compare p p' = GT
        then (p, x) :: (p', x') :: tl
        else (p', x') :: (insert tl p x)
  
  let remove = function
    | [] -> raise EmptyPQueue
    | (p, x) :: tl -> (p, x, tl)
  
end

let sort (type a) (module OrdType : ORDTYPE with type t = a) (xs : a list) =
  let module PQ = MakePQueue (OrdType)
  in let enqueue = List.fold_left (fun pq x -> PQ.insert pq x ()) PQ.empty
  in let dequeue =
    let rec aux acc pq = try
        let p, _, tl = PQ.remove pq in aux (p :: acc) tl
      with PQ.EmptyPQueue -> acc
    in aux []
  in enqueue xs |> dequeue
