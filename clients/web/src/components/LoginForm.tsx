import { ErrorMessage, Field, Form, Formik } from "formik";
import gql from "graphql-tag";
import React from "react";
import { useMutation } from "react-apollo-hooks";
import { SignInMutation, SignInVariables } from "../generated/types";

const SIGNIN_MUTATION = gql`
  mutation signIn($input: SignInInput!) {
    signIn(input: $input) {
      result {
        token
      }
    }
  }
`;

type LoginFormValues = {
  email: string;
  password: string;
};

class FormikLoginForm extends Formik<LoginFormValues> {}

function LoginForm() {
  const signIn = useMutation<SignInMutation, SignInVariables>(SIGNIN_MUTATION);

  return (
    <FormikLoginForm
      initialValues={{ email: "", password: "" }}
      onSubmit={async (values, actions) => {
        const { data } = await signIn({ variables: { input: values } });
        if (data!.signIn!.result) {
          localStorage.setItem("token", data!.signIn!.result!.token!);
        } else {
          localStorage.removeItem("token");
        }

        actions.setSubmitting(false);
      }}
    >
      {({ isSubmitting }) => (
        <Form>
          <Field type="email" name="email" />
          <ErrorMessage name="email" component="div" />
          <Field type="password" name="password" />
          <ErrorMessage name="password" component="div" />
          <button type="submit" disabled={isSubmitting}>
            Submit
          </button>
        </Form>
      )}
    </FormikLoginForm>
  );
}

export default LoginForm;
