;Header and description

(define (domain mars_rover)
(:requirements :strips :typing :conditional-effects :negative-preconditions :equality)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    rover
    location man_pose - locus
    manipulator
    spectrometer camera radar - sensor
    planet
    angle
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at ?r - rover ?l - location) ; is the rover r at location l
    (connected ?l1 ?l2 - location) ; is location l1 connected to location l2
    (unstable ?r - rover) ; is rover r unstable?
    (tack ?r - rover ?m - manipulator) ; is manipulator m attached to rover r
    (ready_to_tack ?r - rover ?mp - man_pose)   ; is the manipulator ready to be tacked
    (has_man ?r - rover ?m - manipulator) ; does rover r have manipulator m
    (has_sensor ?r - rover ?s - sensor) ; does rover r have sensor s
    (at_pose ?m - manipulator ?mp - man_pose) ; is manipulator m at pose mp 
    (sensor_active ?s - sensor) ; is sensor s active
    (information_acquired ?s - sensor) ; has sensor s acquired information
    (analysis_performed ?r - rover ?s - sensor) ; has rover r performed analysis on sensor s
    (aligned ?p1 - planet ?p2 - planet) ; are planets p1 and p2 aligned
    (data_sended ?r - rover ?s - sensor) ; has rover r send data from sensor s 
    (communication_available) ; is communication available
    (communication_closed ?r - rover ?s - sensor ) ; is communication closed
    (sensor_pose ?s - sensor ?mp - man_pose) ; the sensor must be used with the manipulator in a certain position
    (home ?r - rover ?l -location) ; true if the rover is at home
    (ok)
    (at_camera ?c - camera ?l - location) ; camera must be used at location l
    (at_spectrometer ?sp - spectrometer ?l - location) ; spectrometer must be used at location l
    (at_radar ?r - radar ?l - location) ; radar must be used at location l
    
    (count_0 ?s - sensor) ; counters
    (count_1 ?s - sensor)
    (count_2 ?s - sensor)
    (count_3 ?s - sensor)
)


; The functions should be used to have variables that can vary and can be increased
;(:functions
;    (count ?s - sensor ?l - location) ; Count of data collections for each sensor in each location
;    (angle ?p1 - planet ?p2 - planet) ; angle between two planet
;    (pos_x ?p - planet) ; x position of planet p
;    (pos_y ?p - planet) ; y position of planet p
;)


;------------- MOTION --------------

(:action move; action for move the rover from one location to another

    :parameters (?r - rover ?from ?to - location ?m - manipulator)

    :precondition (and
        (at ?r ?from)
        (connected ?from ?to)
        (unstable ?r) ; the rover must be unstable to move
        ;(forall (?m - manipulator)
            (tack ?r ?m) ; the manipulator must be retracted to move, (problem: we should do a for loop over all man)
        ;)
        
    )

    :effect (and
        (at ?r ?to)
        (not (at ?r ?from))
    )
    )


(:action stabilize ; action for stabilize the rover (idea: the rover elongate some arms to stabilize itself)
    :parameters (?r - rover)
    :precondition (unstable ?r)
    :effect  (not(unstable ?r))
)

(:action unstabilize ; action for unstabilize the rover
    :parameters(?r - rover)
    :precondition(not(unstable ?r))
    :effect(unstable ?r)
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


; (PROBLEM: before tack the manipulator the rover should set the manipulator in a certain pose (retracted) )
(:action tack ; retract a manipulator into the main rover chassis (solution: this action include the retraction of the arm)
    :parameters (?r - rover ?m - manipulator ?mp - man_pose)
    :precondition (and 
        (not(tack ?r ?m))
        (has_man ?r ?m)
        (ready_to_tack ?r ?mp)
        (at_pose ?m ?mp)
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
;        (not(information_acquired ?s ?l))
;        (at_pose ?m ?mp)
;        
;        (<= (count ?s ?l) 2) ; Assuming 2 collections required, adjust as needed
;    )
;    :effect (and 
;        (increase (count ?s ?l) 1) ; every time the action is performed increase the counter (does not work)
;        (when (= (count ?s ?l) 2) ; Check if count has reached the required value 
;            (information_acquired ?s ?l)
;        )
;    )
;)

;Camera
(:action aquire_camera_info
    :parameters (?r - rover ?m - manipulator ?c - camera ?l - location ?mp - man_pose)
    :precondition (and 
        (at_camera ?c ?l) ; location where acquire data with camera
        (at ?r ?l)
        (has_sensor ?r ?c)
        (sensor_active ?c)
        (not(unstable ?r))
        (not(information_acquired ?c))
        (sensor_pose ?c ?mp) ; manipulator must be in a certain pose to use the camera properly
        (at_pose ?m ?mp)
        (or (count_0 ?c) (count_1 ?c) (count_2 ?c))
       )
    :effect (and 
            (when (count_0 ?c) (and (not (count_0 ?c)) (count_1 ?c)))
            (when (count_1 ?c) (and (not (count_1 ?c)) (count_2 ?c)))
            (when (count_2 ?c) (and (not (count_2 ?c)) (count_3 ?c) (information_acquired ?c)))
    )
)

;radar
(:action aquire_radar_info
    :parameters (?r - rover ?m - manipulator ?ra - radar ?l - location ?mp - man_pose)
    :precondition (and 
        (at_radar ?ra ?l)
        (at ?r ?l)
        (has_sensor ?r ?ra)
        (sensor_active ?ra) 
        (not(unstable ?r))
        (not(information_acquired ?ra))
        (sensor_pose ?ra ?mp)
        (at_pose ?m ?mp)
        (not(tack ?r ?m))
    )
    :effect (and 
            (information_acquired ?ra)
    )
)

;Spectrometer
(:action aquire_spectrometer_info
    :parameters (?r - rover ?s - spectrometer ?l - location ?m - manipulator ?mp - man_pose)
    :precondition (and 
        (at_spectrometer ?s ?l)
         (at ?r ?l)
        (has_sensor ?r ?s)
        (sensor_active ?s) 
        (not(unstable ?r))
        (not(information_acquired ?s ))
        (sensor_pose ?s ?mp)
        (at_pose ?m ?mp)
    )
    :effect (and 
            (information_acquired ?s)
    )
)

;---------------- Data processing ------------------

(:action perform_analysis ; perform analysis on the acquired information
    :parameters (?r - rover ?m - manipulator ?s - sensor ?l - location ) 
    :precondition (and 
        (has_sensor ?r ?s)
        (information_acquired ?s)
        (not(analysis_performed ?r ?s))
        (not (sensor_active ?s))
        (tack ?r ?m)
    )
    :effect (and 
        (analysis_performed ?r ?s)
        (ok)
    )
)


;---------------- Data transmission ------------------


;; a = 1,496 * 10^11 b = 1,4958 * 10^11

;IDEA: make a process that moves the earth and mars, and then check if they are aligned

;    (:event align
;        :parameters (?e - planet ?m - planet)
;         :precondition (and
;            (or
;                (and
;                    (<= ( decrease( pos_x ?e) (pos_x ?m) ) 10)  ; (x_e - x_m) <= 10
;                    (<= (decrease( pos_y ?e) (pos_y ?e)) 10)    ; (y_e - y_m) <= 10
;                 )
;                
;                (and
;                    (<= (decrease( pos_x ?m) (pos_x ?e)) 10)
;                    (<= (decrease( pos_y ?m) (pos_y ?e)) 10)
;                 )                
;                
;            )
;     
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
;               (assign (time ?delta_t) (#t - t))
;               (increase (pos_x ?e) (* ) )  ; x += vx * delta_t 
;               (increase (pos_y ?e) (* ) ) ; y += vy * delta_t
;               (assign (time ?t) (#t))
;    )
;)



(:action wait_for_comm
    :parameters (?r - rover ?l -location)
    :precondition (and 
        (not(communication_available))
        (ok)
        (home ?r ?l) ; r must be at home
        (at ?r ?l)
    )
    :effect (and (communication_available)
             (not(ok))
    )
)



(:action send_data
    :parameters (?r - rover ?s - sensor ?l2 - location)
    :precondition (and (not(data_sended ?r ?s))
                        (analysis_performed ?r ?s)
                        (communication_available)
                        (home ?r ?l2)
                        (at ?r ?l2)

                   
    )
    :effect (and (data_sended ?r ?s)
    (not (communication_available))
    )
)


(:action close_comm
    :parameters(?r -rover ?s -sensor ?l - location ?m - manipulator)
    :precondition(and (data_sended ?r ?s)
                    (not(communication_closed ?r ?s))

                    )
    
    :effect(and
            (not(communication_available))
            (communication_closed ?r ?s)
            
    )

)



)
