(* PF2018 Lista 5
   Specyfikacja modułu implementującego leniwe strumienie. *)

type 'a t = 'a cell Lazy.t
 and 'a cell = Nil | Cons of 'a * 'a t
val hd : 'a t -> 'a
val tl : 'a t -> 'a t
val (++) : 'a t -> 'a t -> 'a t
val init : (int -> 'a) -> 'a t
val map : ('a -> 'b) -> ('a t -> 'b t)
val map2 : ('a -> 'b -> 'c) -> ('a t -> 'b t -> 'c t)
val combine : 'a t -> 'b t -> ('a * 'b) t
val split : ('a * 'b) t -> 'a t * 'b t
val filter : ('a -> bool) -> 'a t -> 'a t
val find_opt : ('a -> bool) -> 'a t -> 'a option
val concat : 'a t t -> 'a t
val nth : int -> 'a t -> 'a
val take : int -> 'a t -> 'a t
val drop : int -> 'a t -> 'a t
val list_of_stream : 'a t -> 'a list
val stream_of_list : 'a list -> 'a t
