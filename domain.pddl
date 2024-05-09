;Header and description

(define (domain mars_rover)
(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    rover
    location
    maniupulator
    man_pose
    sensors
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at ?r - rover ?l - location) ; is the rover r at location l
    (connected ?l1 ?l2 - location) ; is location l1 connected to location l2
    (unstable ?l - location) ; is location l unstable?
    (tack ?r - rover ?m - maniupulator) ; is maniupulator m attached to rover r
    (has_man ?r - rover ?m - maniupulator) ; does rover r have maniup
    (has_sensor ?r - rover ?s - sensors) ; does rover r have sensor s
    (at_pose ?m - maniupulator ?mp - man_pose) ; is maniupulator m at pose mp 

)

(:action move; action for move the rover from one location to another

    :parameters (?r - rover ?from ?to - location)

    :precondition (and
        (at ?r ?from)
        (connected ?from ?to)
    )

    :effect (and
        (at ?r ?to)
        (not (at ?r ?from))
    )
    )


(:action stabilize; action for stabilize the robot ina  certain location)
    :parameters (?r - rover ?l - location)
    :precondition (and 
        (at ?r ?l)
        (unstable ?l)
    )
    :effect (and 
        (not(unstable ?l))
    )
)

(:action untack ; (sganciare) elongate a maniupulator out of the main rover chassis
    :parameters (?r - rover ?m - maniupulator)

    :precondition (and  
        (tack ?r ?m)
        (has_man ?r ?m)
    )
    :effect (and 
        (not(tack ?r ?m))
    )
)

(:action set_manipulator
    :parameters (?r - rover ?m - maniupulator ?init ?final - man_pose)
    :precondition (and 
        
     )
    :effect (and )
)







)



