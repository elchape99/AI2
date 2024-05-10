;Header and description

(define (domain mars_rover)
(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    rover
    location
    manipulator
    man_pose
    sensor
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at ?r - rover ?l - location) ; is the rover r at location l
    (connected ?l1 ?l2 - location) ; is location l1 connected to location l2
    (unstable ?r - rover) ; is rover r unstable?
    (tack ?r - rover ?m - manipulator) ; is maniupulator m attached to rover r
    (has_man ?r - rover ?m - manipulator) ; does rover r have maniup
    (has_sensor ?r - rover ?s - sensor) ; does rover r have sensor s
    (at_pose ?m - maniupulator ?mp - man_pose) ; is maniupulator m at pose mp 
    (sensor_active ?s - sensor) ; is sensor s active
    (information_acquired ?s - sensor); has sensor s acquired information

)

(:action move; action for move the rover from one location to another

    :parameters (?r - rover ?from ?to - location)

    :precondition (and
        (at ?r ?from)
        (connected ?from ?to)
        ;(unstable ?r) ; the rover must be unstable to move
        ;(tack ?r ?m) ; the manipulator must be retracted to move, PROBLEM: we should do a for loop over all manipulators
    )

    :effect (and
        (at ?r ?to)
        (not (at ?r ?from))
    )
    )


;(:action stabilize; action for stabilize the robot in a  certain location)
;    :parameters (?r - rover ?l - location)
;    :precondition (and 
;        (at ?r ?l)
;        (unstable ?l)
;    )
;    :effect (and 
;        (not(unstable ?l))
;    )
;)

(:action stabilize ; action for stabilize the robot)
    :parameters (?r - rover)
    :precondition (and 
        (unstable ?r)
    )
    :effect (and 
        (not(unstable ?r))
    )
)

(:action untack ; (sganciare) elongate a manipulator out of the main rover chassis
    :parameters (?r - rover ?m - manipulator)

    :precondition (and  
        (tack ?r ?m)
        (has_man ?r ?m)
    )
    :effect (and 
        (not(tack ?r ?m))
    )
)

;;;;;;;;;; NEW ACTIONS ;;;;;;;;;;;;;;

(:action set_manipulator ; position the manipulator E-E in a certain pose 
    :parameters (?r - rover ?m - manipulator ?init ?final - man_pose)
    :precondition (and 
        (has_man ?r ?m)
        (at_pose ?m ?init)
        
     )
    :effect (and 
        (not (at_pose ?m ?init))
        (at_pose ?m ?final)
    )
)

(:action tack ; (agganciare) retract a maniupulator into the main rover chassis
    :parameters (?r - rover ?m - manipulator)
    :precondition (and 
        (not(tack ?r ?m)) ; NEG precond
        (has_man ?r ?m)
    )
    :effect (and (tack ?r ?m))
)

(:action activate_sensor ; activate a sensor
    :parameters (?r - rover ?s - sensor)
    :precondition (and 
        (has_sensor ?r ?s)
        (not(sensor_active ?s))
    )
    :effect (and (sensor_active ?s))
)

(:action deactivate_sensor ; deactivate a sensor
    :parameters (?r - rover ?s - sensor)
    :precondition (and 
        (has_sensor ?r ?s)
        (sensor_active ?s)
    )
    :effect (and (not (sensor_active ?s)))
)


(:action aquire_information ; acquire information from a sensor ;TODO: REVIEW this action
    :parameters (?r - rover ?s - sensor ?l - location)
    :precondition (and 
        (at ?r ?l)
        (has_sensor ?r ?s)
        (sensor_active ?s)
        (not(unstable ?r))
        (not(information_acquired ?s))
    )
    :effect (and 
        (information_acquired ?s)
    )
)









)



