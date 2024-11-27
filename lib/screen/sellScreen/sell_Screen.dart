import 'package:farm_connects/layout/appbar_layout.dart';
import 'package:farm_connects/screen/sellScreen/multi_step_sell_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../config/network/local/cache_helper.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../cubits/sell_cubit/sell_States.dart';
import '../../cubits/sell_cubit/sell_cubit.dart';
import '../../widgets/custom_text_field.dart';
import '../../cubits/home_cubit/home_cubit.dart';

class SellScreen extends StatefulWidget {
  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    locationController.text =
    '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(key: 'subDistrict') ?? ''}';
    nameController.text = CacheHelper.getData(key: 'name') ?? "";
    var profileCubit = ProfileCubits.get(context);
    mobileController.text = profileCubit.profileModel.data?.mobile ?? "";
  }

  @override
  void dispose() {
    locationController.dispose();
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.watch<HomeCubit>();

    return BlocProvider(
      create: (context) => SellCubit(),
      child: Scaffold(
        appBar:PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Card(
            elevation: 2,
            child: AppBarLayout(isDark: homeCubit.isDark),
          ),
        ),
        body: BlocConsumer<SellCubit, SellFormState>(
          listener: (context, state) {
            if (state is SellFormState && state.showSnackbar != null) {
              state.showSnackbar(context);
            }
          },
          builder: (context, state) {
            final cubit = context.read<SellCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Section
                      Image.asset(
                        'assets/images/used-tractor-banner.webp',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 15),
                      // Form Section
                      Container(
                        decoration: BoxDecoration(
                          color: homeCubit.isDark ?Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8.0,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sell Your Used Tractor',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: homeCubit.isDark ?Colors.white : Colors.black,),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: locationController,
                              hintText: 'Location',
                              icon: Icons.location_on,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Location is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: nameController,
                              hintText: "Name",
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: mobileController,
                              hintText: "Mobile Number",
                              icon: Icons.phone,
                              inputType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mobile number is required';
                                }
                                if (value.length != 13) {
                                  return 'Mobile number must be 10 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            if (state is SellFormSubmitting)
                              const Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ),
                      if (state is! SellFormSubmitting)
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Get.to(
                                MultiStepSellScreen(
                                  location: locationController.text,
                                  name: nameController.text,
                                  mobile: mobileController.text,
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.blue),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              side: BorderSide(color: Colors.blue, width: 1),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
