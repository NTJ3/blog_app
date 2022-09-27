import 'dart:io';

import 'package:blog_app/core/constant/text_styles.dart';
import 'package:blog_app/core/firebase/firebase_functions.dart';
import 'package:blog_app/core/index.dart';
import 'package:blog_app/core/util/snackbar.dart';
import 'package:blog_app/core/util/utility.dart';
import 'package:blog_app/ui/blogs/bloc/blogs.dart';
import 'package:blog_app/ui_components/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBlogScreen extends StatefulWidget {
  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _desFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late BlogsBloc _blogsBloc;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController =
      new TextEditingController(text: '');
  final TextEditingController _desController =
      new TextEditingController(text: '');

  final List<String> _blogsCategories = ["SPORTS", "MOVIES"];
  String _selectedBlogCategory = "SPORTS";
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _blogsBloc = BlocProvider.of<BlogsBloc>(context);
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _onCreateBlogButtonPressed() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      _formKey.currentState!.save();

      _blogsBloc.add(
        CreateBlogButtonPressed(
            title: _titleController.text,
            des: _desController.text,
            category: _selectedBlogCategory,
            context: context,
            imageFile: _imageFile),
      );
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<BlogsBloc, BlogsState>(
      key: _scaffoldKey,
      listener: (context, state) {
        log.info('===> listener $state');
        if (state is BlogsFailure) {
          showToast(state.error, context, isError: true);
        } else if (state is BlogsSuccess) {
          _autoValidateMode = AutovalidateMode.disabled;
          showToast(Strings.message.kCreateBlogSuccess, context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(Strings.screenTitle.kCreateBlogScreen),
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autoValidateMode,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: _onUploadImage,
                            child: Card(
                              child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: _imageFile != null
                                      ? Image.file(_imageFile!)
                                      : Icon(
                                          Icons.image,
                                          size: 55,
                                        )),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          TextFormField(
                            focusNode: _titleFocus,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            onSaved: (value) =>
                                _titleController.text = value?.trim() ?? "",
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, _titleFocus, _desFocus);
                            },
                            validator: (value) => Validator.validateEmptyString(
                                value, Strings.message.kEnterBlogTitle),
                            decoration:
                                TextStyles.getInputDecoration().copyWith(
                              hintText: Strings.hint.kBlogTitle,
                            ),
                          ),
                          SizedBox(height: 12.0),
                          TextFormField(
                            focusNode: _desFocus,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            textInputAction: TextInputAction.newline,
                            onSaved: (value) =>
                                _desController.text = value?.trim() ?? "",
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, _desFocus, FocusNode());
                            },
                            validator: (value) => Validator.validateEmptyString(
                                value, Strings.message.kEnterBlogDes),
                            decoration:
                                TextStyles.getInputDecoration().copyWith(
                              hintText: Strings.hint.kBlogDescription,
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(Strings.label.kSelectBlogCategory),
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedBlogCategory,
                            items: _blogsCategories
                                .map((String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            onChanged: (category) {
                              setState(() {
                                _selectedBlogCategory = category!;
                              });
                            },
                          ),
                          SizedBox(height: 12.0),
                          CustomAppButton(
                            showLoader: state is BlogsLoading,
                            text: Strings.button.kSubmit,
                            textColor: Colors.white,
                            backgroundColor: Colors.blue,
                            onPressed: _onCreateBlogButtonPressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));

  void _onUploadImage() async {
    File? imageFile = await Utility.pickImage(context);

    setState(() {
      _imageFile = imageFile;
    });
  }
}
