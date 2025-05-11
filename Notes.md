## Magic system parameters

### Elements

Params: 
* LeftHandElement
* RightHandElement

Values:
0. None
1. Lightning
2. Fire
3. Ice
4. Light
5. Dark
6. Wind

### Spells

Params:
* SpellLeftIndex
* SpellRightIndex

0. None
1. Charge
2. Spray
3. Weapon
4. Aura
5. Cast

### Spell Stages
//TODO: COOLDOWNS!!!
#### Charge
* Ready: Immediately
* Prepare: Gesture = 1
* Release: 1800ms

#### Spray
* Inactive: Unless active
* Active: Gesture = 2, AFK = false

#### Weapon
* Ready (weapon hidden): Immediately
* Active (weapon visible): Close circle -> Gesture = 5
* Attack: Gesture = 1
>**Note:** Disabled when circle is open!


#### Aura
* Ready: Immediately
* Active: Gesture = 1

#### Cast
* Ready: Immediately
* Prepeare: Gesture = 1
* Fire: Gesture != 1 & >3000ms

## Sensation parameters

### Elemental params

Min duration: 300ms

#### Lightning

Frequency: 45Hz
Intensity: 60%

Pattern: Simple, continuous

#### Fire
Frequency: 26Hz
Intensity: 28%

#### Ice
Frequency: 75Hz
Intensity: 30%

#### Light
Frequency: 100Hz
Intensity: 15%

#### Dark
Frequency: 5Hz
Intensity: 100%

#### Wind
Frequency: 100Hz
Fade in: 100ms
Intensity: 40% 


### Spells

#### Charge
* Fade in on front (fade = charge time - 200ms)
* Throw effect on release

#### Spray
* Inactive: Continuous in arm (L/R) (half-intensity)
* Active: Continuous in arm (L/R)+ Pectoral (L/R)

#### Weapon
* Sensation on front + arm (L/R)
* Short (300ms) intensity increase on slash (except for ice)

#### Aura
* Sensation in entire body when active (half-intensity?)

#### Cast
* Sensation in arm (L/R) while casting (fade = charge time - 200ms)
* Sensation in front on spell firing (fade = 1000ms)


## Sensation files

### Sensation file format

`<SensationPhaseName>_<ElementName>`

### Sensation phase names
Phases ending with "Loop" are looping indefinitely and need to be interruptable

* ChargePrepareLoop
* ChargeFireR
* ChargeFireL
* SprayActiveLoopR
* SprayActiveLoopL
* AuraActiveLoop
* WeaponActiveLoopR
* WeaponActiveLoopL
* WeaponAttackR
* WeaponAttackL
* CastPrepareLoopR
* CastPrepareLoopL
* CastFireR
* CastFireL