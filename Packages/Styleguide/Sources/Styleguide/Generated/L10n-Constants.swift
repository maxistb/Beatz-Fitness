// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Split Hinzufügen
  public static let addSplit = L10n.tr("Localization", "add_split", fallback: "Split Hinzufügen")
  /// Beatz
  public static let beatz = L10n.tr("Localization", "beatz", fallback: "Beatz")
  /// Löschen
  public static let delete = L10n.tr("Localization", "delete", fallback: "Löschen")
  /// Willst du den Trainingsplan wirklich löschen? Dies kann nicht Rückgängig gemacht werden.
  public static let deleteSplitConfirmationDialog = L10n.tr("Localization", "delete_split_confirmation_dialog", fallback: "Willst du den Trainingsplan wirklich löschen? Dies kann nicht Rückgängig gemacht werden.")
  /// Name vom Split
  public static let nameOfSplit = L10n.tr("Localization", "name_of_split", fallback: "Name vom Split")
  /// Eigene Splits
  public static let ownSplits = L10n.tr("Localization", "own_splits", fallback: "Eigene Splits")
  /// Empfohlene Trainingspläne
  public static let recommendedPlans = L10n.tr("Localization", "recommended_plans", fallback: "Empfohlene Trainingspläne")
  /// Speichern
  public static let save = L10n.tr("Localization", "save", fallback: "Speichern")
  /// Statistik
  public static let statistic = L10n.tr("Localization", "statistic", fallback: "Statistik")
  /// Trainingstagebuch
  public static let trainingbook = L10n.tr("Localization", "trainingbook", fallback: "Trainingstagebuch")
  /// Trainingspläne
  public static let trainingplans = L10n.tr("Localization", "trainingplans", fallback: "Trainingspläne")
  /// 🏋🏻 Trainingspläne
  public static let trainingsplansHeader = L10n.tr("Localization", "trainingsplans_header", fallback: "🏋🏻 Trainingspläne")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
