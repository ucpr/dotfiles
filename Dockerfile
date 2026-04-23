FROM denoland/deno:2.7.13

WORKDIR config

COPY . .

CMD ["bash"]
