#### Panels:
- `Action Execution Trend`: The trend of executed actions over time. Grouped by Environment, Entity Type, and Action Type.
- `Action Execution`: Percentage of executed actions by type Environment, Entity Type, and Action Type.
- `Risks Avoided Trend`: The trend of risks avoided over time. Grouped by Action Type and Risk.
- `Labor Saved`: The amount of labor time/cost saved by executing actions. Grouped by Action Type and Entity Type. The "Labor Cost per Hour" can be modifed by editing panel's `Labor Cost/Hour` parameter.
- `Risks Avoided Breakdown`: Risks avoided by percentage grouped by Action Type and Entity Type.
- `Action Details`: Raw table of actions executed and their details.<br>
#### Filter Options:
- `Datetime (UTC)`: Customize the date range of all panels. Default is `Last 20160 Minutes` (14 days). <br>
- `Environment`: Filter for `On-Prem`, `Cloud`, or `Hybrid` environments. ("Hybrid" is used when Turbo is unable to stitch VMs to Cloud or On-Prem infrastructure.)
- `Action Type`: Filter for a specific Action Type. Example: `Move`, `Resize`, `Deactivate`, etc.
- `Entity Type`: Filter for a specific Entity Type. Example: `Virtual_Machine`, `Container_Pod`, `Virtual_Volume`, `Workload_Controller`, etc
- `Mode`: Filter for a specific action Mode. Example: `Automatic` or `Manual`
- `Entity Name`: Filter for a specific Entity Name.<br>

![image](https://github.com/turbonomic/visualization/assets/30292381/8ecb1eaf-396f-4ecb-acb5-996939d64d11)
