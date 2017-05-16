## CacheP4

Examples for validating caching mechanism.


### Examples
| Program | Features |
| :---: | :---: |
| P1  | router |
| P2  | nat + router |
| P3  | source guard + acl + nat + router |

### Test results

#### P1 RTT
| times | origin (ms) | cache hit (ms) | cache miss (ms) |
| :---: | :---: | :---: | :----: |
| 1 | 0.914 | 0.891 | 0.929 |
| 2 | 0.888 | 0.881 | 0.940 |
| 3 | 0.899 | 0.886 | 0.929 |
| avg | 0.900(0.00%) | 0.886(-1.56%) | 0.933(+3.67%) |


#### P1 Throughput
| times | origin (Mbps) | cache hit (Mbps) | cache miss (Mbps) |
| :---: | :---: | :---: | :----: |
| 1 | 201 | 224 | 172 |
| 2 | 196 | 223 | 163 |
| 3 | 201 | 228 | 167 |
| avg | 199(0.00%) | 225(+13.07%) | 167(-16.08%) |

#### P2 RTT
| times | origin (ms) | cache hit (ms) | cache miss (ms) |
| :---: | :---: | :---: | :----: |
| 1 | 1.220 | 1.000 | 1.253 |
| 2 | 1.198 | 1.015 | 1.240 |
| 3 | 1.204 | 1.020 | 1.280 |
| avg | 1.207(0.00%) | 1.012(-16.16%) | 1.258(+4.23%) |

#### P2 Throughput
| times | origin (Mbps) | cache hit (Mbps) | cache miss (Mbps) |
| :---: | :---: | :---: | :----: |
| 1 | 90.1 | 120 | 77.8 |
| 2 | 91.8 | 127 | 78.1 |
| 3 | 89.5 | 126 | 79.0 |
| avg | 90.5(0.00%) | 124(+37.02%) | 78.3(-13.48%) |

#### P3 RTT
| times | origin (ms) | cache hit (ms) | cache miss (ms) |
| :---: | :---: | :---: | :----: |
| 1 | 1.355 | 1.059 | 1.435 |
| 2 | 1.348 | 1.066 | 1.421 |
| 3 | 1.332 | 1.060 | 1.446 |
| avg | 1.345(0.00%) | 1.062(-21.04%) | 1.434(+6.62%) |

#### P3 Throughput
| times | origin (Mbps) | cache hit (Mbps) | cache miss (Mbps) |
| :---: | :---: | :---: | :----: |
| 1 | 66.9 | 110 | 57.3 |
| 2 | 67.0 | 108 | 59.1 |
| 3 | 65.7 | 111 | 59.7 |
| avg | 66.5(0.00%) | 110(+65.41%) | 58.7(-11.73%) |

### Test method

See README.md in each program folders for detailed test method.
