import 'package:deals/features/auth/presentation/views/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/widgets/custom_button.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/widgets/error_message_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/settings/presentation/manager/cubits/delete_reasons_cubit/delete_reasons_cubit.dart';

/// Screen body for confirming account deletion with reason checkboxes.
class DeleteAccountViewBody extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onDelete;
  final String? errorMessage;

  const DeleteAccountViewBody({
    super.key,
    required this.isLoading,
    required this.onDelete,
    this.errorMessage,
  });

  @override
  State<DeleteAccountViewBody> createState() => _DeleteAccountViewBodyState();
}

class _DeleteAccountViewBodyState extends State<DeleteAccountViewBody> {
  // 1) ScrollController to persist scroll position
  final ScrollController _scrollController = ScrollController();


  bool _agreed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<DeleteReasonsCubit, DeleteReasonsState>(
      builder: (context, state) {
        if (state is DeleteReasonsLoading || state is DeleteReasonsInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DeleteReasonsFailure) {
          return Center(
            child: ErrorMessageCard(
              title: S.of(context).UnexpectedError,
              message: 'Unable to load reasons.',
              onRetry: () =>
                  context.read<DeleteReasonsCubit>().loadReasons(),
            ),
          );
        }
        final reasons =
            state is DeleteReasonsSuccess ? state.reasons : <String>[];
        return Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.errorMessage != null)
                    ErrorMessageCard(
                      title: widget.errorMessage!,
                      message: 'Please try again later.',
                    ),
                  ...reasons.map((text) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _BulletItem(text: text),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        CustomCheckBox(
                          isChecked: _agreed,
                          onChecked: (v) => setState(() => _agreed = v),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            s.iHaveReadTheTermsAndIAgreeOnThem,
                            style: AppTextStyles.bold14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    onPressed: (_agreed && !widget.isLoading)
                        ? widget.onDelete
                        : () {},
                    text: s.deleteAccount,
                    buttonColor: _agreed
                        ? AppColors.accent
                        : AppColors.accent.withValues(alpha: 0.5),
                    textColor: Colors.white,
                    isLoading: widget.isLoading,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            if (widget.isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('•', style: TextStyle(fontSize: 20, height: 1.4)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.regular14,
          ),
        ),
      ],
    );
  }
}
