[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md)

Introduction
============

Haxen is currently in a research stage and is not yet suitable for real projects.

Haxen "Haxe Engine" is a small simulation engine in development since 12/01/2015. 
While the initial focus is on a 2D sprite-based engine, optional 3D voxel and 
implicit surface components may get added if the 2D pipeline becomes stable.

Haxen is built on the principles of physical simulation, in that only data which
contributes to the simulation outputs (display, speakers) gets processed or 
allocated in memory. Data is stored in a serialized form in a base class
called Base.hx with a static physical body. When this static body enters the
simulation region of interest (Simulation.hx) it becomes instantiated as a
dynamic Entity.hx which gets processed each frame until its body leaves the
simulation region of interest.

Base.hx can only contain one Entity.hx instance type which is coupled with a 
physical body. This is different to typical entity systems, such as in Unity3D, 
that instead build the entity model on a Transform class. Our approach means 
that all entities occupy a bounded region of physical space such that we can 
robustly determine what entities contribute to the hierarchical simulation.
Hierarchy in an optional scene graph can still be modelled by creating a Node.hx
entity which contains child entities whose sub-regions update their parent
regions accordingly.

Roadmap
-------

1. Camera
2. Make the core 2D entities stable (Button, Sound)
3. JSON universe format for Base.hx
4. Mobile testing and Input
5. (optional) Addons Entity library (GUI Widgets, Character Controller, ...)
6. (optional) Haxen Editor library
7. Abstract 2D parts and port @cwkx 3D GPU voxel research

Canvas.hx
=========

Canvas.hx holds the main sprite which manages the top-level update loop. It
configures how Timestep.hx updates the physics with respect to the drawing.

There are four time step functions to choose from:
	
 * Fixed 	 - stable, choppy
 * Variable - unstable, smooth
 * Bounded	 - semi-stable, semi-smooth
 * Discrete - stable, semi-smooth

Writing game logic is handled in the form of systems and entities. Typically
95% of a game is categorised into writing new entities and extended the existing
ones. See the documentation on the Simulation.hx section.

There is one physical universe per project. To support multiple scenes or states, 
the Node.hx entity can be used to group hierarchical physical regions of space.

Simulation.hx
=============

In the Simulation.hx class there are two physical boxes. Scene content is stored 
in a set of static physics boxes called Base.hx. If a Base enters the inner box,
its Entity data (animations, sounds, tilemaps, text) gets created. If the body of 
the spawned Entity.hx leaves the outter simulation box, the Entity.hx data gets 
destroyed.

This means that only contributing data gets created in memory and processed.

    +---------------------------------------+
    |										|
    |										|
    |		+---------------+				|
    |		|	o			|				|
    |		|	|-/			|<-Inner Box	|
    |		|	/\			|				|
    |		+---------------+				|
    |										|
    |<-Simulation Box						|
    |										|
    +---------------------------------------+

As a rule, a base can only store ONE entity.

    Base->Entity
    		@-Body

Node is a type of entity for grouping other entities, e.g. for component design
like in Unity3D or other hierarchical scene graphs.

    Base->Node:Entity
    		@-Body
    		@-"gun"
    		|-Anim
    		|-Sound
    		|-Tiled
    		|-Node
    			@-Body
    			@-"bullet 1"
    			Body
    			|-Anim
    			|-Sound
    		|-Node
    			@-Body
    			@-"bullet 2"
			
Infinite chunked tilemap supported by:

    Base->Tiled:Entity
    		@-Body
		
Or, if huge amounts of tilemaps with HUGE amounts of physics:

    Base->Node:Entity
    		@-Body
    		@-"big map with lots of colliders"
    		|-Entity "collider 1"
    		|-Entity "collider 2"
    		|-Entity "collider 3"