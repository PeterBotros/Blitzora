import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/example_bloc.dart';
import '../widgets/example_widget.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: BlocBuilder<ExampleBloc, ExampleState>(
        builder: (context, state) {
          if (state is ExampleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExampleLoaded) {
            return ExampleWidget(example: state.example);
          } else if (state is ExampleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExampleBloc>().add(const GetExampleEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<ExampleBloc>().add(const GetExampleEvent());
              },
              child: const Text('Load Example'),
            ),
          );
        },
      ),
    );
  }
}
