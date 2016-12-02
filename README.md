# simtracker
SimTracker is a MATLAB-based software package that provides a suite of tools to support the process of NEURON simulation management.

To install SimTracker, 


Documentation available at: http://mariannebezaire.com/simtracker/

Support available at: https://www.neuron.yale.edu/phpBB/viewtopic.php?f=42&t=3512

SimTracker suite contains the following tools:
SimTracker - simulation management: allows users to design simulations, specify code version and parameters, execute the simulation on their computer or a supercomputer, and analyze the results.

CellData - analyzes experimental data to create constraints for model components. Currently reads in AxoClamp-style files containing current injection sweep data, and produces tables and figures of single cell electrophysiological properties.

CellClamp - applies various experimental characterization protocols to the network, including ion channel activation and inactivation protocols, single cell current injection sweeps, and paired recordings of synaptic connections between two cells.

NetworkClamp - performs a 'network clamp'-style of simulation where a single cell is extracted from the network with all its incoming connections in place. Modeler can specify the stimulation protocol applied to the cell (either the same activity it received during a full network simulation, or an idealized or otherwise custom input specified by the modeler). Simulation can be performed on personal computer.

WebsiteMaker - produces an analysis of the model network components in a website template or a LaTeX template (for PDF files).

These tools together can support a full modeling process. For a graphical description of how they fit into the process, see: http://mariannebezaire.com/simtracker-workflow-and-context/
