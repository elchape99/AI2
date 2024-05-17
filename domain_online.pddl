;Header and description

(define (domain mars_rover)
(:requirements :strips :fluents :typing :conditional-effects :negative-preconditions :equality)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    rover
    location man_pose - locus ;;;
    ;man_pose
    manipulator
    spectrometer camera radar - sensor
    ;counter
    planet
    angle
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at ?r - rover ?l - location) ; is the rover rP at location l
    (connected ?l1 ?l2 - location) ; is location l1 connected to location l2
    (unstable ?r - rover) ; is rover r unstable?
    (tack ?r - rover ?m - manipulator) ; is manipulator m attached to rover r
    (has_man ?r - rover ?m - manipulator) ; does rover r have maniup
    (has_sensor ?r - rover ?s - sensor) ; does rover r have sensor s
    (at_pose ?m - manipulator ?mp - man_pose) ; is manipulator m at pose mp 
    (sensor_active ?s - sensor) ; is manipulatorsensor s active
    (information_acquired ?s - sensor ?mp - man_pose ?l - location); has sensor s acquired information
    (analysis_performed ?r - rover ?s - sensor ?l - location ?mp - man_pose) ; has rover r performed analysis on sensor s (added mp)
    (aligned ?p1 - planet ?p2 - planet) ; are planets p1 and p2 aligned
    (data_sended ?r - rover ?l - location ?s - sensor ?mp - man_pose)    ; has rover r send data
    (communication_available) ; is communication available
    (communication_closed ?r - rover ?l - location ?s - sensor ?mp - man_pose ?mp1 - man_pose) 
    (ready_for_task ?r ?s ?mp ?l)
    (sensor_pose ?r ?s ?mp) ; how should man pose to use a sensor

)


; The functions should be used to have variables that can vary and can be increased
;(:functions
;    (count ?s - sensor ?l - location) ; Count of data collections for each sensor in each location
;    (angle ?p1 - planet ?p2 - planet) ; angle between two planet
;)


;------------- MOTION --------------

(:action move; action for move the rover from one location to another

    :parameters (?r - rover ?from ?to - location ?m - manipulator)

    :precondition (and
        (at ?r ?from)
        (connected ?from ?to)
        (unstable ?r) ; the rover must be unstable to move
        (tack ?r ?m) ; the manipulator must be retracted to move, PROBLEM: we should do a for loop over all manipulators
    )

    :effect (and
        (at ?r ?to)
        (not (at ?r ?from))
    )
    )


(:action stabilize ; action for stabilize the robot
    :parameters (?r - rover)
    :precondition (and 
        (unstable ?r)
    )
    :effect (and 
        (not(unstable ?r))
    )
)

;--------- Deployment of Scientfic Instruments ---------

(:action untack ; elongate a manipulator out of the main rover chassis
    :parameters (?r - rover ?m - manipulator)

    :precondition (and  
        (tack ?r ?m)
        (has_man ?r ?m)
        (not(unstable ?r))
    )
    :effect (and 
        (not(tack ?r ?m))
    )
)


(:action set_manipulator ; position the manipulator E-E in a certain pose 
    :parameters (?r - rover ?m - manipulator ?init ?final - man_pose)
    :precondition (and 
        (has_man ?r ?m)
        (at_pose ?m ?init)
        (not(tack ?r ?m))
        (not(unstable ?r))
     )
    :effect (and 
        (not (at_pose ?m ?init))
        (at_pose ?m ?final)
    )
)


; PROBLEM: before tack the manipulator the rover should set the manipulator in a certain pose (retracted)
(:action tack ; retract a manipulator into the main rover chassis
    :parameters (?r - rover ?m - manipulator)
    :precondition (and 
        (not(tack ?r ?m)) ; NEG precond
        (has_man ?r ?m)
    )
    :effect (and (tack ?r ?m))
)


;----------------- Data collection -----------------

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


;IDEA: the number of times informations must be aquired depends on the type of analys and sensor use
;PROBLEM: DO A DIFFERENT ACTION FOR EVERY SENSOR for the parameter OR try to pass it from the problem file  
;(:action aquire_information
;    :parameters (?r - rover ?s - sensor ?l - location ?m - manipulator ?mp - man_pose)
;    :precondition (and 
;        (at ?r ?l)
;        (has_sensor ?r ?s)
;        (sensor_active ?s)
;        (not(tack ?r ?m)) ; Manipulator must be out to collect data, 
;        (not(unstable ?r))
;        (not(information_acquired ?s ?mp ?l))
;        (at_pose ?m ?mp)
;        
;        (<= (count ?s ?l) 2) ; Assuming 2 collections required, adjust as needed
;    )
;    :effect (and 
;        (increase (count ?s ?l) 1) ; every time the action is performed increase the counter (does not work)
;        (when (= (count ?s ?l) 2) ; Check if count has reached the required value 
;            (information_acquired ?s ?mp ?l)
;        )
;    )
;)

;Camera
(:action aquire_camera_info
    :parameters (?r - rover ?c - camera ?l - location ?m - manipulator ?mp - man_pose)
    :precondition (and 
        (at ?r ?l)
        (has_sensor ?r ?c)
        (sensor_active ?c)
        (not(tack ?r ?m)) ; Manipulator must be out to collect data, 
        (not(unstable ?r))
        (not(information_acquired ?c ?mp ?l))
        (at_pose ?m ?mp)
    )
    :effect (and 
            (information_acquired ?c ?mp ?l)
    )
)

;radar
(:action aquire_radar_info
    :parameters (?r - rover ?ra - radar ?l - location ?m - manipulator ?mp - man_pose)
    :precondition (and 
        (at ?r ?l)
        (has_sensor ?r ?ra)
        (sensor_active ?ra)
        (not(tack ?r ?m)) ; Manipulator must be out to collect data, 
        (not(unstable ?r))
        (not(information_acquired ?ra ?mp ?l))
        (at_pose ?m ?mp)
    )
    :effect (and 
            (information_acquired ?ra ?mp ?l)
    )
)

;Spectrometer
(:action aquire_spectrometer_info
    :parameters (?r - rover ?s - spectrometer ?l - location ?m - manipulator ?mp - man_pose)
    :precondition (and 
        (at ?r ?l)
        (has_sensor ?r ?s)
        (sensor_active ?s)
        (not(tack ?r ?m)) ; Manipulator must be out to collect data, 
        (not(unstable ?r))
        (not(information_acquired ?s ?mp ?l))
        (at_pose ?m ?mp)
    )
    :effect (and 
            (information_acquired ?s ?mp ?l)
    )
)

;---------------- Data processing ------------------

(:action perform_analysis ; perform analysis on the acquired information
    :parameters (?r - rover ?s - sensor ?mp - man_pose ?l - location) 
    :precondition (and 
        (has_sensor ?r ?s)
        (information_acquired ?s ?mp ?l)
        (not(analysis_performed ?r ?s ?l ?mp));;?mp
        (at ?r ?l)
    )
    :effect (and 
        (analysis_performed ?r ?s ?l ?mp)
    )
)


;---------------- Data transmission ------------------


;; a = 1,496 * 10^11 b = 1,4958 * 10^11

;IDEA: make a process that moves the earth and mars, and then check if they are aligned

;    (:event align
;        :parameters (?m - planet ?e - planet)
;         :precondition (and
;            (or
;                (<= (angle ?m ?e) 20)
;                (<= (angle ?e ?m) 20) 
;                
;            )
;        )
;        :effect (and
;            (aligned ?m ?e)
;        )
;    )

;(:process motion_earth
;    :parameters (?e - planet)
;    :precondition (and
;        ; activation condition
;    )
;    :effect (and
;        ; continuous effect(s)
;    )
;)



(:action wait_for_comm
    :parameters (?r - rover ?s - sensor ?l - location ?mp - man_pose)
    :precondition (and 
        (has_sensor ?r ?s)
        (analysis_performed ?r ?s ?l ?mp)
        (not(communication_available))
    )
    :effect (and (communication_available))
)



;PROBLEM: the rover must be at the location in which it aquire data in order to send data?
(:action send_data
    :parameters (?r - rover ?s - sensor ?mp - man_pose ?l - location)
    :precondition (and (not(data_sended ?r ?l ?s ?mp))
                        (analysis_performed ?r ?s ?l ?mp)
                        (information_acquired ?s ?mp ?l)
                        (communication_available)
                        ;(ready_for_task ?r ?s ?mp ?l)
    )
    :effect (and (data_sended ?r ?l ?s ?mp)
                 (not(ready_for_task ?r ?s ?mp ?l))
    )
)

(:action close_comm
    :parameters(?r -rover ?s -sensor ?mp - man_pose ?mp1 - man_pose ?l - location ?m - manipulator)
    :precondition(and (data_sended ?r ?l ?s ?mp)
                    (not(communication_closed ?r ?l ?s ?mp ?mp1))
                    (at_pose ?m ?mp)
                    )
    
    :effect(and(not(data_sended ?r ?l ?s ?mp))
            (not(communication_available ))
            (communication_closed ?r ?l ?s ?mp ?mp1)
            (at_pose ?m ?mp1)
            (tack ?r ?m)
            (unstable ?r)
            
            
    )

)

)




