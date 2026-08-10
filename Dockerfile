FROM denoland/deno:2.9.5

WORKDIR config

COPY . .

CMD ["bash"]
