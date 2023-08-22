part of '../select_account_screen.dart';

class _Search extends StatelessWidget {
  const _Search({
    required this.controller,
    this.onChanged,
  });
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyleUtils.regular(13),
      decoration: InputDecoration(
        prefixIcon: const Icon(CupertinoIcons.search),
        hintText: AppText.search,
        hintStyle: TextStyleUtils.regular(13).copyWith(
          color: const Color(0xFF969696),
        ),
        isDense: true,
        filled: true,
        focusColor: ColorUtils.blue,
        fillColor: const Color(0xFFEFEFEF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: BlocBuilder<SelectAccountBloc, SelectAccountState>(
          builder: (context, state) {
            return controller.text.isNotEmpty == true
                ? IconButton(
                    icon: const Icon(Icons.clear_outlined),
                    onPressed: () {
                      context.read<SelectAccountBloc>().add(
                            SelectAccountSearchEvent(searchQuery: ''),
                          );
                      controller.clear();
                    },
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
