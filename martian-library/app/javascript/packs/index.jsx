import React from 'react';
import { render } from 'react-dom';
import Provider from '../components/Provider';
import UserInfo from '../components/UserInfo';
import AddItemForm from '../components/AddItemForm';
import Library from '../components/Library';

render(
  <Provider>
    <UserInfo />
    <AddItemForm />
    <Library />
  </Provider>,
  document.querySelector('#root')
);
