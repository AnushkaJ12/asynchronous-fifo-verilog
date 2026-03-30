## Designed asynchronous FIFO for safe data transfer across clock domains using Gray-coded pointers and dual-flop synchronization to prevent metastability.

## Key Concepts

- Clock Domain Crossing (CDC)
- Metastability mitigation using 2-flop synchronizers
- Gray code pointer synchronization
- Full and Empty flag generation

## Architecture

- write_ctrl.v → write pointer + Gray conversion
- read_ctrl.v → read pointer logic
- sync_r2w.v → synchronizes read pointer into write clock domain
- sync_w2r.v → synchronizes write pointer into read clock domain
- fifo_mem.v → storage

  
## Simulation Result
<img width="1857" height="632" alt="waveform" src="https://github.com/user-attachments/assets/7d22bb0f-a394-4944-bd10-881a8035bac3" />


## Physical Design Results (OpenLane - SKY130)

- Successfully executed RTL-to-GDSII flow
- Stages covered:
  - Synthesis
  - Floorplanning
  - Placement
  - Clock Tree Synthesis (CTS)
  - Routing

<img width="1918" height="1026" alt="GDSII layout" src="https://github.com/user-attachments/assets/4f78865b-d04b-46b0-9b4a-cbae8660ad14" />
