import { navigate } from "@reach/router";
import { ErrorMessage, Field, Form, Formik } from "formik";
import React from "react";
import useSignIn from "../hooks/useSignIn";

type LoginFormValues = {
  email: string;
  password: string;
};

class FormikLoginForm extends Formik<LoginFormValues> {}

const LoginForm: React.SFC = React.memo(function(props) {
  const signIn = useSignIn();

  return (
    <FormikLoginForm
      initialValues={{ email: "", password: "" }}
      onSubmit={async (values, actions) => {
        const isAuthenticated = await signIn({ input: values });
        actions.setSubmitting(false);
        actions.resetForm();

        if (isAuthenticated) {
          navigate("/positions");
        } else {
          actions.setError(new Error("super"));
        }
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
});

export default LoginForm;
