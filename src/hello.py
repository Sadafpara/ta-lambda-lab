#lambda handler, the entry point to your code
def lambda_handler(event, context):
    print(context.function_name)
    print("Hello World")