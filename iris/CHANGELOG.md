# Changelog

## [1.0.2] - 2026-07-14

### Fixed
- IRIS BI textMeter widgets: added `dataProperty` bindings in `Overview.dashboard` — DSW 4.x only renders measures listed in data properties
- IRIS BI UomTable: replaced removed `Country.Uom` property with `[idwaterresultuom].[H1].[Label]` row level (fixes `@NOPROPERTY`)
- KPI pivots (`MeanPollution`, `MeanOutsideInfluence`, `VenueCount`): measure defined via `columnLevel` instead of deprecated `<measure>` element

## [1.0.1] - 2026-07-14

### Fixed
- Docker build: replaced deprecated PyPI package `sklearn` with `scikit-learn` in `requirements.txt`
- Docker build: removed automatic cube build from ZPM `Invokes` — failed cube activation rolled back module installation and data
- Flask/Dash app: replaced obsolete `app.run_server()` with `app.run()` for Dash 4.x compatibility
- Container startup: replaced `exit 1` with `wait` in `server_start.sh` so background processes keep running
- DeepSee cube: removed duplicate `Uom` property from `Country` level in `waterPollutionCube` (18 833 build errors)
- IRIS BI / DSW: added `SetupDSWAddons()` to register and compile `DSW.Addons.*` portlet classes for worldMap and other addons

### Added
- `App.Installer.BuildCubes()` — builds `waterPollutionCube` after ZPM data load
- `App.Installer.SetupDSWAddons()` — registers DSW JS addons via `MDX2JSON.Utils.CreateAddons()`
- `App.Installer` moved to `src/App/Installer.cls` and included in ZPM module as `App.PKG`

### Changed
- `iris.script`: removed duplicate `Installer.cls` reload — class is loaded via ZPM as `App.PKG`

## [1.0.0] - 2022-05-27

- Initial release: water conditions Europe visualization with IRIS BI, Dash timeline, ML predictions
