# OtterHub

## Analysis the txs

```
GYorm4aGhM8UzwGeHaZrYJtP9EF2FWYHkUURCJuUoLyv
- function: create_private_repo 
- effect: create HelloWorld repo

Cgcwm6Ps5rMmJmct2V7PTnJEF8gC5KYr2V2zDCW7XgE5
- function: create_private_repo 
- effect: create Matryoshka repo

5G96ZkJddWVQVUJrAZpMfF7SaAtCRHFGy3CX9Eagx7UZ
- function: create_private_repo
- effect: create Blogger repo

4ngcw9nPeqVvUn5up1XGjHFQTKBNgB7vpk7bopxrsmTK
- function: commit
- effect: commit `"if __name__ == '__main__': print('Hello World!')"` to HelloWorld

EvZs4gexjS1wyxMAsBhZ64Aj6c4FXFo4XDCrQdDK34nv
- function: commit
- effect: commit some bytecode to Matryoshka

Hy1SYeTXauP3UkNJViAa8crP9VHGAkQBiSznio99Y2uT
- function: commit
- effect: commit some bytecode to Matryoshka

9zY7dQCRyHCMDR4kHNNaAJ37zUwbBJVKYG4j7ZqjGHAD
- function: commit
- effect: commit some bytecode to Matryoshka

3sAcTBAR6d2JHtJ9gQ3mXihAGBgJ7GQq6NhK9UZctbeQ
- function: checkout
- effect: change head of Matryoshka

EuztPJmVegZufWVx2vsSivA4dDzfo3J5WWaZrAV2xijD
- function: commit
- effect: commit rick roll to blogger
```

```python
s = [10, 13, 6, 28, 54, 125, 70, 69, 108, 29, 59, 13, 71, 80, 83, 84, 87, 108, 40, 70, 6, 95, 89, 95, 49, 18, 125, 70, 69, 108, 29, 59, 78, 4, 80, 83, 84, 87, 108, 40, 70, 69, 28] + [89, 95, 49, 13, 39, 64, 2, 104, 29, 59, 13, 71, 80, 83, 84, 87, 108, 40, 70, 6, 95, 89, 95, 49, 18, 12, 2, 11, 1, 7, 11, 26, 29, 59, 13, 71, 80, 83, 84, 87, 78, 125]

flag = 'f'
for i in s:
    flag += chr(ord(flag[-1])^i)
print(flag)
```