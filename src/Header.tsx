import React from "react";
import { Link } from "react-router-dom";
import { Anchor, BoxProps, Button, Nav } from "grommet";
import { url } from "./config.json";

import {
  Notification,
  Home as HomeIcon,
  VmMaintenance,
  GraphQl as GraphQlIcon,
} from "grommet-icons";
import { Routes } from "./routes";

const AppBox = (
  props: JSX.IntrinsicAttributes &
    BoxProps &
    React.ClassAttributes<HTMLDivElement> &
    React.HTMLAttributes<HTMLDivElement>
): JSX.Element => {
  return (
    <Nav
      direction="row"
      justify="between"
      align="center"
      elevation="medium"
      pad={{ vertical: "small", horizontal: "medium" }}
      {...props}
    />
  );
};

export const Header = (): JSX.Element => {
  return (
    <AppBox>
      <Link to={Routes.Home}>
        <HomeIcon />
      </Link>
      <Button
        icon={<Notification />}
        onClick={
          // eslint-disable-next-line @typescript-eslint/no-empty-function
          (): void => {}
        }
      />
      <Button></Button>
      {/* <Link to={Routes.Graphql}>
        <GraphQlIcon />
      </Link> */}
      <Anchor href={url} icon={<GraphQlIcon />} />
      <Link to={Routes.Admin}>
        <VmMaintenance />
      </Link>
    </AppBox>
  );
};
