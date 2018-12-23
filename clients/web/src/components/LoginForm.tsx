import React from "react";
import gql from "graphql-tag";
import { Formik, Form, Field, ErrorMessage } from "formik";
import { Mutation } from "react-apollo";
import { SignInVariables, SignInMutation } from "../generated/types";

class LoginFormMutation extends Mutation<SignInMutation, SignInVariables> {}

const SIGNIN_MUTATION = gql`
  mutation signIn($input: SignInInput!) {
    signIn(input: $input) {
      result {
        token
      }
    }
  }
`;

const LoginForm = () => (
  <LoginFormMutation
    onCompleted={data => {
      if (data.signIn && data.signIn.result && data.signIn.result.token) {
        localStorage.setItem("token", data.signIn.result.token);
      }
    }}
    mutation={SIGNIN_MUTATION}
  >
    {login => (
      <Formik
        initialValues={{ email: "", password: "" }}
        onSubmit={(values, { setSubmitting }) => {
          login({
            variables: {
              input: values
            }
          }).then(() => {
            setSubmitting(false);
          });
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
      </Formik>
    )}
  </LoginFormMutation>
);

export default LoginForm;
