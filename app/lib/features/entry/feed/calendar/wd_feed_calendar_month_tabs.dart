part of '../pg_display_feed_entry.dart';

class _FeedCalendarMonthTabs extends StatelessWidget {
  const _FeedCalendarMonthTabs({
    required this.focusedMonth,
    required this.onTapFocusedMonth,
  });

  final DateTime focusedMonth;
  final Future<void> Function() onTapFocusedMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTapFocusedMonth,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              _monthLabel(focusedMonth),
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedCalendarMonthInputDialog extends StatefulWidget {
  const _FeedCalendarMonthInputDialog({required this.initialMonth});

  final DateTime initialMonth;

  @override
  State<_FeedCalendarMonthInputDialog> createState() =>
      _FeedCalendarMonthInputDialogState();
}

class _FeedCalendarMonthInputDialogState
    extends State<_FeedCalendarMonthInputDialog> {
  late final TextEditingController _yearController;
  late final TextEditingController _monthController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _yearController = TextEditingController(
      text: widget.initialMonth.year.toString(),
    );
    _monthController = TextEditingController(
      text: widget.initialMonth.month.toString(),
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _fillCurrentMonth() {
    final now = DateTime.now();
    setState(() {
      _yearController.text = now.year.toString();
      _monthController.text = now.month.toString();
      _errorText = null;
    });
  }

  int _resolvedYear() =>
      int.tryParse(_yearController.text.trim()) ?? widget.initialMonth.year;

  int _resolvedMonth() =>
      int.tryParse(_monthController.text.trim()) ?? widget.initialMonth.month;

  void _setYear(int year) {
    final safeYear = year < 1 ? 1 : year;
    setState(() {
      _yearController.text = safeYear.toString();
      _errorText = null;
    });
  }

  void _setMonth(int month) {
    setState(() {
      _monthController.text = month.toString();
      _errorText = null;
    });
  }

  void _decrementYear() => _setYear(_resolvedYear() - 1);

  void _incrementYear() => _setYear(_resolvedYear() + 1);

  void _decrementMonth() {
    final year = _resolvedYear();
    final month = _resolvedMonth();
    if (month <= 1) {
      _setYear(year - 1);
      _setMonth(12);
      return;
    }
    _setMonth(month - 1);
  }

  void _incrementMonth() {
    final year = _resolvedYear();
    final month = _resolvedMonth();
    if (month >= 12) {
      _setYear(year + 1);
      _setMonth(1);
      return;
    }
    _setMonth(month + 1);
  }

  void _submit() {
    final l10n = context.l10n;
    final year = int.tryParse(_yearController.text.trim());
    final month = int.tryParse(_monthController.text.trim());

    if (year == null || month == null) {
      setState(() {
        _errorText = l10n.pleaseEnterNumbersOnly;
      });
      return;
    }
    if (month < 1 || month > 12) {
      setState(() {
        _errorText = l10n.monthBetweenError;
      });
      return;
    }

    Navigator.of(context).pop(DateTime(year, month));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.selectYearMonth),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          l10n.yearFieldLabel,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: _compactFieldDecoration(
                          context: context,
                          hintText: l10n.yearFieldHint,
                          suffixIcon: _InlineAdjustButtons(
                            onIncrement: _incrementYear,
                            onDecrement: _decrementYear,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          l10n.monthFieldLabel,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _monthController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        onFieldSubmitted: (_) => _submit(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: _compactFieldDecoration(
                          context: context,
                          hintText: l10n.monthFieldHint,
                          suffixIcon: _InlineAdjustButtons(
                            onIncrement: _incrementMonth,
                            onDecrement: _decrementMonth,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _fillCurrentMonth,
                child: Text(l10n.useCurrentMonth),
              ),
            ),
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _errorText!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.apply)),
      ],
    );
  }

  InputDecoration _compactFieldDecoration({
    required BuildContext context,
    required String hintText,
    required Widget suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      isDense: true,
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 30, 10),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints(
        minWidth: 28,
        maxWidth: 28,
        minHeight: 32,
        maxHeight: 32,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: context.colorScheme.primary, width: 1.4),
      ),
    );
  }
}

class _InlineAdjustButtons extends StatelessWidget {
  const _InlineAdjustButtons({
    required this.onIncrement,
    required this.onDecrement,
  });

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 32,
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: onIncrement,
              child: const Center(
                child: Icon(Icons.keyboard_arrow_up_rounded, size: 14),
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: context.colorScheme.outlineVariant.withAlpha(140),
          ),
          Expanded(
            child: InkWell(
              onTap: onDecrement,
              child: const Center(
                child: Icon(Icons.keyboard_arrow_down_rounded, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
